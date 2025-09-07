# Writing a program to check whether the given number is prime or not

def check_prime(number):
    if number<2:
        return False
    for i in range(2,number):
        if number%i == 0:
            return False
    return True

number = 47
result = check_prime(number)
print("Given number is primenumber") if result == True else print("Given number is not primenumber")