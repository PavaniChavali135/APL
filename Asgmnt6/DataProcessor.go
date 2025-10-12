package main

import (
	"fmt"
	"sort"
	"strings"
	"sync"
	"time"
)

/*
Multi-threaded Data Processing System
Copies 3 fixed lines from BufferA to BufferB using goroutines and channels
*/

// Configuration constants
const (
	WRITE_WORKERS   = 3
	READ_WORKERS    = 3
	PACKET_SIZE     = 8  // 8 characters per packet
	MAX_QUEUE_SIZE  = 10 // Channel buffer size
)

// Packet structure to hold data with metadata
type Packet struct {
	LineIndex      int
	SequenceNumber int
	Data           string
}

// String representation of packet for debugging
func (p Packet) String() string {
	return fmt.Sprintf("Packet{line=%d, seq=%d, data='%s'}", p.LineIndex, p.SequenceNumber, p.Data)
}

// Global data structures
var (
	bufferA = []string{
		"I'm not clumsy, it is the floor.",
		"Train'g is my only real defense.",
		"I'm on vegetable diet, I see it.",
	}
	bufferB    = make([]string, 3)
	packetMap  = make(map[int]map[int]string) // lineIndex -> (sequenceNumber -> data)
	mapMutex   sync.RWMutex                   // Protects packetMap
	
	// Channels for communication
	packetQueue    = make(chan Packet, MAX_QUEUE_SIZE)
	lineIndexChan  = make(chan int, len(bufferA))
	
	// Counters
	packetsProcessed int
	counterMutex     sync.Mutex
)

// Initialize system components
func initialize() {
	fmt.Println("=== Multi-threaded Data Processing System (using Go) ===")
	fmt.Printf("Copying 3 lines from BufferA to BufferB using %d write workers and %d read workers\n", 
		WRITE_WORKERS, READ_WORKERS)
	fmt.Println()
	
	// Initialize BufferB and packet map
	for i := 0; i < len(bufferB); i++ {
		bufferB[i] = ""
		packetMap[i] = make(map[int]string)
	}
	
	// Fill line index channel with available lines
	for i := 0; i < len(bufferA); i++ {
		lineIndexChan <- i
	}
	close(lineIndexChan)
	
	fmt.Println("BufferB initialized")
}

// Print BufferA contents
func printBufferA() {
	fmt.Println("\n=== BufferA (Original Data) ===")
	for i, line := range bufferA {
		fmt.Printf("Line %d (%d chars): \"%s\"\n", i, len(line), line)
	}
	fmt.Println()
}

// Write worker function - divides lines into packets and sends to channel
func writeWorker(workerID int, wg *sync.WaitGroup) {
	defer wg.Done()
	fmt.Printf("WriteWorker-%d started\n", workerID)
	
	for lineIndex := range lineIndexChan {
		line := bufferA[lineIndex]
		fmt.Printf("WriteWorker-%d processing line %d: \"%s\"\n", workerID, lineIndex, line)
		
		// Divide line into 8-character packets
		divideLineIntoPackets(line, lineIndex, workerID)
	}
	
	fmt.Printf("WriteWorker-%d finished\n", workerID)
}

// Divide a line into 8-character packets and send to channel
func divideLineIntoPackets(line string, lineIndex int, workerID int) {
	sequenceNumber := 0
	
	for start := 0; start < len(line); start += PACKET_SIZE {
		end := start + PACKET_SIZE
		if end > len(line) {
			end = len(line)
		}
		
		packetData := line[start:end]
		packet := Packet{
			LineIndex:      lineIndex,
			SequenceNumber: sequenceNumber,
			Data:           packetData,
		}
		
		// Send packet to channel (blocks if channel is full)
		packetQueue <- packet
		
		fmt.Printf("WriteWorker-%d added packet: \"%s\" (line %d, seq %d)\n", 
			workerID, packetData, lineIndex, sequenceNumber)
		
		sequenceNumber++
		
		// Small delay to simulate processing time
		time.Sleep(10 * time.Millisecond)
	}
}

// Read worker function - retrieves packets from channel and reconstructs BufferB
func readWorker(workerID int, wg *sync.WaitGroup) {
	defer wg.Done()
	fmt.Printf("ReadWorker-%d started\n", workerID)
	
	for packet := range packetQueue {
		// Process the packet
		processPacket(packet, workerID)
		
		// Update counter safely
		counterMutex.Lock()
		packetsProcessed++
		counterMutex.Unlock()
	}
	
	fmt.Printf("ReadWorker-%d finished\n", workerID)
}

// Process a packet and add it to the packet map
func processPacket(packet Packet, workerID int) {
	// Store packet in map by line and sequence number (thread-safe)
	mapMutex.Lock()
	packetMap[packet.LineIndex][packet.SequenceNumber] = packet.Data
	mapMutex.Unlock()
	
	fmt.Printf("ReadWorker-%d processed packet: \"%s\" (line %d, seq %d)\n", 
		workerID, packet.Data, packet.LineIndex, packet.SequenceNumber)
	
	// Small delay to simulate processing time
	time.Sleep(5 * time.Millisecond)
}

// Reconstruct BufferB from packet map in correct order
func reconstructBufferB() {
	mapMutex.RLock()
	defer mapMutex.RUnlock()
	
	for lineIndex := 0; lineIndex < len(bufferB); lineIndex++ {
		lineMap := packetMap[lineIndex]
		
		// Get sequence numbers and sort them
		var sequences []int
		for seq := range lineMap {
			sequences = append(sequences, seq)
		}
		sort.Ints(sequences)
		
		// Concatenate packets in correct order
		var builder strings.Builder
		for _, seq := range sequences {
			builder.WriteString(lineMap[seq])
		}
		
		bufferB[lineIndex] = builder.String()
	}
}

// Print BufferB contents
func printBufferB() {
	// First reconstruct BufferB from packet map
	reconstructBufferB()
	
	fmt.Println("=== BufferB (Copied Data) ===")
	for i, line := range bufferB {
		fmt.Printf("Line %d (%d chars): \"%s\"\n", i, len(line), line)
	}
	fmt.Println()
}

// Validate that BufferB matches BufferA
func validateBuffers() {
	fmt.Println("=== Buffer Validation ===")
	allMatch := true
	
	for i := 0; i < len(bufferA); i++ {
		matches := bufferA[i] == bufferB[i]
		if matches {
			fmt.Printf("Line %d: MATCHED \n", i)
		} else {
			fmt.Printf("Line %d: MISMATCHED \n", i)
			fmt.Printf("  Expected: \"%s\"\n", bufferA[i])
			fmt.Printf("  Got:      \"%s\"\n", bufferB[i])
			allMatch = false
		}
	}
	
	fmt.Println()
	if allMatch {
		fmt.Println("Result: All LINES MATCHED ")
	} else {
		fmt.Println("Result: VALIDATION FAILED ")
	}
	
	counterMutex.Lock()
	fmt.Printf("Total packets processed: %d\n", packetsProcessed)
	counterMutex.Unlock()
	fmt.Println()
}

// Run the complete data processing pipeline
func runDataProcessing() error {
	var writeWG, readWG sync.WaitGroup
	
	// Start write workers
	writeWG.Add(WRITE_WORKERS)
	for i := 1; i <= WRITE_WORKERS; i++ {
		go writeWorker(i, &writeWG)
	}
	
	// Start read workers
	readWG.Add(READ_WORKERS)
	for i := 1; i <= READ_WORKERS; i++ {
		go readWorker(i, &readWG)
	}
	
	// Wait for all write workers to complete
	writeWG.Wait()
	fmt.Println("All write workers completed")
	
	// Close packet queue to signal read workers to finish
	close(packetQueue)
	
	// Wait for all read workers to complete
	readWG.Wait()
	fmt.Println("All read workers completed")
	
	return nil
}

// Main function
func main() {
	startTime := time.Now()
	
	// Initialize system
	initialize()
	
	// Print original BufferA
	printBufferA()
	
	// Run processing pipeline
	err := runDataProcessing()
	if err != nil {
		fmt.Printf("Error during processing: %v\n", err)
		return
	}
	
	// Print results
	printBufferB()
	validateBuffers()
	
	// Show processing time
	endTime := time.Now()
	processingTime := endTime.Sub(startTime)
	fmt.Printf("Processing completed in %v\n", processingTime)
	fmt.Println("Data processing successful!")
}

