#!/usr/bin/env python3


class StatisticsCalculator:
    """
    A class to calculate basic statistics (mean, median, mode) for a list of integers.
    
    Attributes:
        data (list): List of integers for statistical calculations
    """
    
    def __init__(self, data=None):
        """
        Initialize the StatisticsCalculator with optional data.
        
        Args:
            data (list, optional): List of integers. Defaults to None (empty list).
        """
        self.data = data if data is not None else []
    
    def set_data(self, data):
        """
        Set or update the data for statistical calculations.
        
        Args:
            data (list): List of integers
        """
        if not isinstance(data, list):
            raise TypeError("Data must be a list")
        self.data = data
    
    def get_data(self):
        """
        Get the current data.
        
        Returns:
            list: Current list of integers
        """
        return self.data
    
    def calculate_mean(self):
        """
        Calculate the mean (average) of the data.
        
        Returns:
            float: Mean value of the data
            
        Raises:
            ValueError: If the data list is empty
        """
        if not self.data:
            raise ValueError("Cannot calculate mean of empty dataset")
        
        total_sum = sum(self.data)
        count = len(self.data)
        mean = total_sum / count
        
        return mean
    
    def calculate_median(self):
        """
        Calculate the median (middle value) of the data.
        
        Returns:
            float: Median value of the data
            
        Raises:
            ValueError: If the data list is empty
        """
        if not self.data:
            raise ValueError("Cannot calculate median of empty dataset")
        
        # Create a sorted copy to avoid modifying original data
        sorted_data = sorted(self.data)
        n = len(sorted_data)
        
        # If odd number of elements, return middle element
        if n % 2 == 1:
            median = sorted_data[n // 2]
        # If even number of elements, return average of two middle elements
        else:
            middle1 = sorted_data[n // 2 - 1]
            middle2 = sorted_data[n // 2]
            median = (middle1 + middle2) / 2.0
        
        return median
    
    def calculate_mode(self):
        """
        Calculate the mode (most frequently occurring value) of the data.
        
        Returns:
            dict: Dictionary containing:
                - 'value': The mode value
                - 'frequency': Frequency of the mode
                
        Raises:
            ValueError: If the data list is empty
        """
        if not self.data:
            raise ValueError("Cannot calculate mode of empty dataset")
        
        # Create a frequency dictionary
        frequency_dict = {}
        for num in self.data:
            frequency_dict[num] = frequency_dict.get(num, 0) + 1
        
        # Find the maximum frequency
        max_frequency = max(frequency_dict.values())
        
        # Find the first value with maximum frequency
        mode_value = None
        for key, value in frequency_dict.items():
            if value == max_frequency:
                mode_value = key
                break
        
        result = {
            'value': mode_value,
            'frequency': max_frequency
        }
        
        return result
    
    def calculate_all_statistics(self):
        """
        Calculate all statistics (mean, median, mode) at once.
        
        Returns:
            dict: Dictionary containing all statistical measures
        """
        return {
            'mean': self.calculate_mean(),
            'median': self.calculate_median(),
            'mode': self.calculate_mode()
        }
    
    def print_statistics(self):
        """
        Display all statistics in a formatted manner.
        """
        if not self.data:
            print("No data available for calculation")
            return
        
       
        # Display the data
        print(f"\nData: {self.data}")
        print(f"Count: {len(self.data)}")
        
        # Calculate and print mean
        mean = self.calculate_mean()
        print(f"\nMean (Average): {mean:.2f}")
        
        # Calculate and print median
        median = self.calculate_median()
        print(f"Median (Middle Value): {median:.2f}")
        
        # Calculate and print mode
        mode_result = self.calculate_mode()
        print(f"Mode (Most Frequent): {mode_result['value']} "
              f"(appears {mode_result['frequency']} time(s))")
        

    
    def add_value(self, value):
        """
        Add a single value to the dataset.
        
        Args:
            value (int): Integer value to add
        """
        if not isinstance(value, (int, float)):
            raise TypeError("Value must be a number")
        self.data.append(int(value))
    
    def clear_data(self):
        """
        Clear all data from the calculator.
        """
        self.data = []
    
    def __str__(self):
        """
        String representation of the StatisticsCalculator.
        
        Returns:
            str: String describing the calculator and its data
        """
        return f"StatisticsCalculator(data={self.data}, count={len(self.data)})"
    
    def __repr__(self):
        """
        Official string representation of the StatisticsCalculator.
        
        Returns:
            str: Representation string
        """
        return f"StatisticsCalculator({self.data})"


def get_user_input():
    """
    Get integer input from the user.
    
    Returns:
        list: List of integers entered by the user
    """
    
    while True:
        try:
            n = int(input("\nEnter the number of integers: "))
            if n <= 0:
                print("Please enter a positive number")
                continue
            break
        except ValueError:
            print("Invalid input. Please enter a valid integer.")
    
    data = []
    print(f"\nEnter {n} integers:")
    for i in range(n):
        while True:
            try:
                value = int(input(f"  Element {i+1}: "))
                data.append(value)
                break
            except ValueError:
                print("Invalid input. Please enter an integer.")
    
    return data


def main():
    print("=== Integers Statistics Calculations ===\n\n")

    # User input mode
    data = get_user_input()
    calculator = StatisticsCalculator(data)
    calculator.print_statistics()  



if __name__ == "__main__":
    main()
