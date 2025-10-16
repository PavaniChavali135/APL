#include <stdio.h>
#include <stdlib.h>


// Function to calculate the mean (average) of an array of integers
double calculateMean(int *arr, int n) {
    if (n == 0) {
        printf("Num of elements is 0\n");
        return 0.0;
    }

    if(!arr) {
        printf("Array is invalid\n");
        return 0.0;
    }    
    
    long long sum = 0;  // Use long long to prevent overflow
    for (int i = 0; i < n; i++) {
        sum += arr[i];
    }
    
    return (double)sum / n;
}

// Function to swap two integers (helper function for sorting)
void swap(int *a, int *b) {
    if(!a || !b) {
        printf("Invalid arguments\n");
        return;
    }

    int temp = *a;
    *a = *b;
    *b = temp;
}


//Function to sort an array using bubble sort algorithm 
void bubbleSort(int *arr, int n) {

    if(!arr) {
        printf("Array is invalid\n");
        return;
    }

    if (n <= 1) {
        return;
    }

    for (int i = 0; i < n - 1; i++) {
        for (int j = 0; j < n - i - 1; j++) {
            if (arr[j] > arr[j + 1]) {
                swap(&arr[j], &arr[j + 1]);
            }
        }
    }
}

// Function to calculate the median of an array of integers
double calculateMedian(int *arr, int n) {
    if (n == 0 || !arr) {
        printf("Array is empty \n");
        return 0.0;
    }
    
    // Sort the array first
    bubbleSort(arr, n);
    
    // If odd number of elements, return middle element
    // If even number of elements, return average of two middle elements
    if (n % 2 == 1) {
        return (double)arr[n / 2];
    }
    else {
        return (double)(arr[n / 2 - 1] + arr[n / 2]) / 2.0;
    }
}

typedef struct {
    int value;      // The mode value
    int frequency;  // Frequency of the mode
    int count;      // Number of modes (for multimodal distributions)
} ModeResult;

// Function to calculate the mode of an array of integers
ModeResult calculateMode(int *arr, int n) {
    ModeResult result = {0, 0, 0};
    
    if (n == 0 || !arr) {
        printf("Array is empty\n");
        return result;
    }
    
    // Sort the array first (if not already sorted)
    bubbleSort(arr, n);
    
    int maxFrequency = 0;
    int currentFrequency = 1;
    int modeValue = arr[0];
    int modeCount = 0;
    
    // Count frequencies
    for (int i = 1; i < n; i++) {
        if (arr[i] == arr[i - 1]) {
            currentFrequency++;
        } else {
            if (currentFrequency > maxFrequency) {
                maxFrequency = currentFrequency;
                modeValue = arr[i - 1];
                modeCount = 1;
            } else if (currentFrequency == maxFrequency) {
                modeCount++;
            }
            currentFrequency = 1;
        }
    }
    
    // Check the last element
    if (currentFrequency > maxFrequency) {
        maxFrequency = currentFrequency;
        modeValue = arr[n - 1];
        modeCount = 1;
    } else if (currentFrequency == maxFrequency) {
        modeCount++;
    }
    
    result.value = modeValue;
    result.frequency = maxFrequency;
    result.count = modeCount;
    
    return result;
}

// Function to display the array
void printArray(int *arr, int n) {
    printf("Array is: ");
    for (int i = 0; i < n; i++) {
        printf("%d \t", arr[i]);
    }
    printf("\n");
}


// Main function to demonstrate statistics calculations
int main() {
    int n;
    int *arr = NULL;
    
    printf("=== Integers Statistics Calculations ===\n\n");
    
    // Get number of elements from user
    printf("Enter the number of integers: ");
    if (scanf("%d", &n) != 1 || n <= 0) {
        printf("Invalid input. Please enter a positive integer.\n");
        return 1;
    }
    
    // Dynamically allocate memory for the array
    arr = (int *)malloc(n * sizeof(int));
    if (arr == NULL) {
        printf("Memory allocation failed\n");
        return 1;
    }
    
    // Input array elements
    printf("Enter %d integers:\n", n);
    for (int i = 0; i < n; i++) {
        printf("Element %d: ", i + 1);
        if (scanf("%d", &arr[i]) != 1) {
            printf("Invalid input\n");
            free(arr);  // Free allocated memory before exiting
            return 1;
        }
    }
    
    printf("\n");
    printArray(arr, n);
    
    // Create a copy for median calculation (since it modifies the array)
    int *arrCopy = (int *)malloc(n * sizeof(int));
    if (arrCopy == NULL) {
        printf("Memory allocation failed\n");
        free(arr);
        return 1;
    }
    
    for (int i = 0; i < n; i++) {
        arrCopy[i] = arr[i];
    }
    
    // Calculate and display statistics
    printf("\n=== Statistics ===\n");
    
    // Mean
    double mean = calculateMean(arr, n);
    printf("Mean: %.2f\n", mean);
    
    // Median
    double median = calculateMedian(arrCopy, n);
    printf("Median: %.2f\n", median);
    
    // Mode
    ModeResult mode = calculateMode(arr, n);
    printf("Mode: %d (appears %d time(s))\n", mode.value, mode.frequency);
    
    // Free dynamically allocated memory
    free(arr);
    free(arrCopy);
 
    return 0;
}
