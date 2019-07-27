
name = input("What is your name: ")
age = int(input("How old are you: "))
print(f"{name}, you will be 100 years old in the year {100-age+2019}")

number = int(input("Give me a whole number: "))
odd_even = "odd" if number %% 2 != 0 else "even"
print(f"That number is an {odd_even} number")

list_nums = [1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89]
list_less_5 = [i for i in list_nums if i < 5]

a = [1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89]
b = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13]
c = list(set(a).intersection(set(b)))

str_test = input("Give me a word: ")
print("Palindrome!" if str_test.lower() == str_test[::-1].lower() else "Not a palindrome")
