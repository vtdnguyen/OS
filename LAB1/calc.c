#include "common.h"
int calculate(int num1, char op, int num2) {
    switch (op) {
        case '+':
            return num1 + num2;
        case '-':
            return num1 - num2;
        case '*':
            return num1 * num2;
        case '%':
            if (num2 != 0) {
                return num1 % num2;
            } else {
                printf("MATH ERROR\n");
                return maxint;
            }
        default:
            printf("SYNTAX ERROR\n");
            return maxint;
    }
}
double calculate_divide(int num1, char op, int num2){
    if (num2 != 0) {
        double result = (double)num1 / num2;
        if (result == (int)result) {
            return result;
        } else {
            return round(result * 100) / 100; // Round to 2 decimal places
        }
    } else {
        printf("MATH ERROR\n");
        return maxint;
    }
}

void waiting(){
    char cont;
    printf("Press ENTER button to continue...");
    getch(); // Read a character
     //while ((cont = getchar()) != '\n' && cont != EOF); // Flush stdin
    return;
}

int save_number(double number, const char* filename) {

  FILE* file = fopen(filename, "w");
  if (file == NULL) {
    return -1;
  }

  // Write the number to the file
  fprintf(file, "%f", number);

  // Close the file
  fclose(file);

  return 0; // Success
}

double read_number(const char* filename) {
  // Open the file in read mode ("r")
  FILE* file = fopen(filename, "r");
  if (file == NULL) {
    // Error handling: couldn't open the file (might not exist)
    return maxint;
  }

  double number;

  // Read the number from the file using fscanf
  fscanf(file, "%lf", &number);

  // Close the file
  fclose(file);

  return number;
}

char* process_string(const char *input) {
    char *result = malloc(strlen(input) + 1); // Allocate memory for the result string
    if (result == NULL) {
        printf("Memory allocation failed.\n");
        exit(1);
    }
    strcpy(result, input); // Copy input to result

    // Search for "ANS" in the result string
    char *ans_ptr = strstr(result, "ANS");
    if (ans_ptr != NULL) {
        // If "ANS" found, calculate its integer value
        int ans_value = (int)read_number(ans_file);
        
        // Replace "ANS" with its integer value in the result string
        sprintf(ans_ptr, "%d%s", ans_value, ans_ptr + 3);
    }

    return result;
}

int main(){
    char operation[20];
    while (true){
        int num1, num2;
        char op;
        printf("\n>> ");
        scanf("%s", operation);
        getchar();

        if (strcmp(operation, "EXIT") == 0) {
            printf("Exiting program...\n");
            break; // Exit the loop
        }
        if (strcmp(operation, "exit") == 0) {
            printf("Exiting program...\n");
            break; // Exit the loop
        }
        if (strcmp(operation, "ANS") == 0) {
            double ans = read_number(ans_file);
            if (ans == maxint ) printf("ERROR\n");
            else 
                (ans == (int)ans)? printf("%d\n", (int)ans) : printf("%.2lf\n",ans);
            waiting();
            continue; // Exit the loop
        }

        char *ope = process_string(operation);
        // Perform operations based on user input here
        if (sscanf(ope, "%d%c%d", &num1, &op, &num2) != 3) {
            printf("SYNTAX ERROR\n");
            waiting();
            continue;
        }

        
        if (op == '/'){ 
            double result = 0;
            result = calculate_divide(num1, op, num2);
            if (result != INT_MAX && result != (int)result) 
                printf("%.2lf\n", result);
            else 
                printf("%d\n",(int)result);
            int success = save_number(result, ans_file);
        }
        else{
            int result = 0;
            result = calculate(num1, op, num2);
            if (result != INT_MAX) 
                printf("%d\n", result);
            int success = save_number(result, ans_file);
        }
        
        waiting();
    }
    
    return 0;
}