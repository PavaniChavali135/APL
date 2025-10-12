import java.util.concurrent.*;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.*;

/**
 * Multi-threaded Data Processing System
 * Copies 3 fixed lines from BufferA to BufferB using worker threads and shared queue
 */
public class DataProcessor {
    
    // Configuration
    private static final int WRITE_WORKERS = 3;
    private static final int READ_WORKERS = 3;
    private static final int PACKET_SIZE = 8; // 8 characters per packet
    private static final int MAX_QUEUE_SIZE = 10;
    
    // Shared data structures
    private static String[] bufferA = {
        "I'm not clumsy, it is the floor.",
        "Train'g is my only real defense.",
        "I'm on vegetable diet, I see it."
    };
    private static String[] bufferB = new String[3];
    private static Map<Integer, Map<Integer, String>> packetMap = new ConcurrentHashMap<>(); // lineIndex -> (sequenceNumber -> data)
    private static BlockingQueue<String> packetQueue = new LinkedBlockingQueue<>(MAX_QUEUE_SIZE);
    
    // Shared counters
    private static AtomicInteger nextLineIndex = new AtomicInteger(0);
    private static AtomicInteger packetsProcessed = new AtomicInteger(0);
    private static volatile boolean allPacketsAdded = false;
    
    /**
     * Main entry point
     */
    public static void main(String[] args) {
        System.out.println("=== Multi-threaded Data Processing System ===");
        System.out.println("Copying 3 lines from BufferA to BufferB using " + 
                          WRITE_WORKERS + " write workers and " + READ_WORKERS + " read workers");
        System.out.println();
        
        long startTime = System.currentTimeMillis();
        
        try {
            // Initialize BufferB
            initializeBufferB();
            
            // Print original BufferA
            printBufferA();
            
            // Start processing
            runDataProcessing();
            
            // Print results
            printBufferB();
            validateBuffers();
            
            long endTime = System.currentTimeMillis();
            System.out.println("Processing completed in " + (endTime - startTime) + " milliseconds");
            System.out.println(" Data processing successful!");
            
        } catch (Exception e) {
            System.err.println("Error during processing: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    /**
     * Initialize BufferB and packet map
     */
    private static void initializeBufferB() {
        for (int i = 0; i < bufferB.length; i++) {
            bufferB[i] = "";
            packetMap.put(i, new ConcurrentHashMap<>());
        }
        System.out.println("BufferB initialized");
    }
    
    /**
     * Run the complete data processing pipeline
     */
    private static void runDataProcessing() throws InterruptedException {
        // Create thread pools
        ExecutorService writeExecutor = Executors.newFixedThreadPool(WRITE_WORKERS);
        ExecutorService readExecutor = Executors.newFixedThreadPool(READ_WORKERS);
        
        try {
            // Start write workers
            for (int i = 0; i < WRITE_WORKERS; i++) {
                final int workerId = i + 1;
                writeExecutor.submit(() -> writeWorkerFunction(workerId));
            }
            
            // Start read workers
            for (int i = 0; i < READ_WORKERS; i++) {
                final int workerId = i + 1;
                readExecutor.submit(() -> readWorkerFunction(workerId));
            }
            
            // Wait for write workers to complete
            writeExecutor.shutdown();
            writeExecutor.awaitTermination(10, TimeUnit.SECONDS);
            allPacketsAdded = true;
            System.out.println("All write workers completed");
            
            // Wait for read workers to complete
            readExecutor.shutdown();
            readExecutor.awaitTermination(10, TimeUnit.SECONDS);
            System.out.println("All read workers completed");
            
        } finally {
            if (!writeExecutor.isShutdown()) {
                writeExecutor.shutdownNow();
            }
            if (!readExecutor.isShutdown()) {
                readExecutor.shutdownNow();
            }
        }
    }
    
    /**
     * Write worker function - divides lines into packets and adds to queue
     */
    private static void writeWorkerFunction(int workerId) {
        System.out.println("WriteWorker-" + workerId + " started");
        
        try {
            while (true) {
                // Get next line to process
                int lineIndex = nextLineIndex.getAndIncrement();
                
                if (lineIndex >= bufferA.length) {
                    break; // No more lines to process
                }
                
                String line = bufferA[lineIndex];
                System.out.println("WriteWorker-" + workerId + " processing line " + lineIndex + ": \"" + line + "\"");
                
                // Divide line into 8-character packets
                divideLineIntoPackets(line, lineIndex, workerId);
            }
            
        } catch (Exception e) {
            System.err.println("WriteWorker-" + workerId + " error: " + e.getMessage());
        }
        
        System.out.println("WriteWorker-" + workerId + " finished");
    }
    
    /**
     * Divide a line into 8-character packets and add to queue
     */
    private static void divideLineIntoPackets(String line, int lineIndex, int workerId) {
        try {
            for (int start = 0; start < line.length(); start += PACKET_SIZE) {
                int end = Math.min(start + PACKET_SIZE, line.length());
                String packet = line.substring(start, end);
                
                // Create packet with metadata: "lineIndex:sequenceNumber:data"
                int sequenceNumber = start / PACKET_SIZE;
                String packetWithMetadata = lineIndex + ":" + sequenceNumber + ":" + packet;
                
                // Add packet to queue (blocking if queue is full)
                packetQueue.put(packetWithMetadata);
                
                System.out.println("WriteWorker-" + workerId + " added packet: \"" + packet + 
                                 "\" (line " + lineIndex + ", seq " + sequenceNumber + ")");
                
                // Small delay to simulate processing time
                Thread.sleep(10);
            }
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            System.err.println("WriteWorker-" + workerId + " interrupted");
        }
    }
    
    /**
     * Read worker function - retrieves packets from queue and reconstructs BufferB
     */
    private static void readWorkerFunction(int workerId) {
        System.out.println("ReadWorker-" + workerId + " started");
        
        try {
            while (true) {
                // Get packet from queue with timeout
                String packetWithMetadata = packetQueue.poll(1, TimeUnit.SECONDS);
                
                if (packetWithMetadata == null) {
                    if (allPacketsAdded && packetQueue.isEmpty()) {
                        break; // No more packets to process
                    }
                    continue; // Keep waiting for more packets
                }
                
                // Process the packet
                processPacket(packetWithMetadata, workerId);
                packetsProcessed.incrementAndGet();
            }
            
        } catch (Exception e) {
            System.err.println("ReadWorker-" + workerId + " error: " + e.getMessage());
        }
        
        System.out.println("ReadWorker-" + workerId + " finished");
    }
    
    /**
     * Process a packet and add it to the packet map
     * Packets are stored by line and sequence number to ensure correct ordering
     */
    private static void processPacket(String packetWithMetadata, int workerId) {
        try {
            // Parse packet: "lineIndex:sequenceNumber:data"
            String[] parts = packetWithMetadata.split(":", 3);
            if (parts.length != 3) {
                System.err.println("Invalid packet format: " + packetWithMetadata);
                return;
            }
            
            int lineIndex = Integer.parseInt(parts[0]);
            int sequenceNumber = Integer.parseInt(parts[1]);
            String data = parts[2];
            
            // Store packet in map by line and sequence number
            Map<Integer, String> lineMap = packetMap.get(lineIndex);
            lineMap.put(sequenceNumber, data);
            
            System.out.println("ReadWorker-" + workerId + " processed packet: \"" + data + 
                             "\" (line " + lineIndex + ", seq " + sequenceNumber + ")");
            
            // Small delay to simulate processing time
            Thread.sleep(5);
            
        } catch (Exception e) {
            System.err.println("ReadWorker-" + workerId + " error processing packet: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    /**
     * Print BufferA contents
     */
    private static void printBufferA() {
        System.out.println("\n=== BufferA (Original Data) ===");
        for (int i = 0; i < bufferA.length; i++) {
            System.out.println("Line " + i + " (" + bufferA[i].length() + " chars): \"" + bufferA[i] + "\"");
        }
        System.out.println();
    }
    
    /**
     * Print BufferB contents
     */
    private static void printBufferB() {
        // Reconstruct BufferB from packet map in correct order
        for (int lineIndex = 0; lineIndex < bufferB.length; lineIndex++) {
            Map<Integer, String> lineMap = packetMap.get(lineIndex);
            StringBuilder lineBuilder = new StringBuilder();
            
            // Sort by sequence number and concatenate packets
            TreeMap<Integer, String> sortedPackets = new TreeMap<>(lineMap);
            for (String packet : sortedPackets.values()) {
                lineBuilder.append(packet);
            }
            
            bufferB[lineIndex] = lineBuilder.toString();
        }
        
        System.out.println("=== BufferB (Copied Data) ===");
        for (int i = 0; i < bufferB.length; i++) {
            System.out.println("Line " + i + " (" + bufferB[i].length() + " chars): \"" + bufferB[i] + "\"");
        }
        System.out.println();
    }
    
    /**
     * Validate that BufferB matches BufferA
     */
    private static void validateBuffers() {
        System.out.println("=== Buffers Validation ===");
        boolean allMatch = true;
        
        for (int i = 0; i < bufferA.length; i++) {
            boolean matches = bufferA[i].equals(bufferB[i]);
            System.out.println("Line " + i + ": " + (matches ? "MATCHED" : "MISMATCHED"));
            
            if (!matches) {
                System.out.println("  Expected: \"" + bufferA[i] + "\"");
                System.out.println("  Got:      \"" + bufferB[i] + "\"");
                allMatch = false;
            }
        }
        
        System.out.println();
        System.out.println("Overall Result: " + (allMatch ? "ALL LINES MATCHED" : "VALIDATION FAILED "));
        System.out.println("Total packets processed: " + packetsProcessed.get());
        System.out.println();
    }
}