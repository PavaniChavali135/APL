// Writing the program to count number vowels in string
#include <iostream>
#include <string>

int count_vowels(std::string name)
{
    int len_str = name.length();
    int count = 0;
    for (int i = 0; i < len_str; i++)
    {
        if (name[i] == 'a' || name[i] == 'e' || name[i] == 'i' || name[i] == 'o' || name[i] == 'u')
        {
            count++;
        }
    }
    return count;
}

int main()
{
    int result = count_vowels("semantics");
    std::cout << result << std::endl;

    return 0;
}