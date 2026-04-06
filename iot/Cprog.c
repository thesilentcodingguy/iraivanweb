#include <stdio.h>

int main() {
    int n, values[100];
    int *ptr, i, max, min;

    scanf("%d", &n);
    for(i = 0; i < n; i++) scanf("%d", &values[i]);

    ptr = values;
    max = min = *ptr;

    for(i = 1; i < n; i++) {
        if(*(ptr + i) > max) max = *(ptr + i);
        if(*(ptr + i) < min) min = *(ptr + i);
    }

    printf("%d", max - min);
    return 0;
}


#include <stdio.h>

struct Student {
    int marks1, marks2, marks3, finalMarks;
};

int main() {
    struct Student s;

    scanf("%d %d %d", &s.marks1, &s.marks2, &s.marks3);

    s.finalMarks = (s.marks1 + s.marks2 + s.marks3) / 3;

    if(s.finalMarks >= 90) printf("A");
    else if(s.finalMarks >= 75) printf("B");
    else if(s.finalMarks >= 50) printf("C");
    else printf("Fail");

    return 0;
}

#include <stdio.h>

int main() {
    int n, values[100];
    int *ptrs[100];
    int i, j;
    int *temp;

    scanf("%d", &n);
    for(i = 0; i < n; i++) {
        scanf("%d", &values[i]);
        ptrs[i] = &values[i];
    }

    for(i = 0; i < n - 1; i++) {
        for(j = i + 1; j < n; j++) {
            if(*ptrs[i] > *ptrs[j]) {
                temp = ptrs[i];
                ptrs[i] = ptrs[j];
                ptrs[j] = temp;
            }
        }
    }

    printf("%d", *ptrs[n - 2]);
    return 0;
}

#include <stdio.h>

int sumDigits(int num) {
    if(num == 0) return 0;
    return num % 10 + sumDigits(num / 10);
}

int main() {
    int num;
    scanf("%d", &num);
    printf("%d", sumDigits(num));
    return 0;
}


#include <stdio.h>
#include <string.h>

struct Product {
    int id;
    char name[50];
    float price;
};

int main() {
    int n, i, j;
    struct Product products[100], temp;

    scanf("%d", &n);
    for(i = 0; i < n; i++) {
        scanf("%d %s %f", &products[i].id, products[i].name, &products[i].price);
    }

    for(i = 0; i < n - 1; i++) {
        for(j = i + 1; j < n; j++) {
            if(products[i].price > products[j].price) {
                temp = products[i];
                products[i] = products[j];
                products[j] = temp;
            }
        }
    }

    for(i = 0; i < n; i++) {
        printf("%d %s %.2f\n", products[i].id, products[i].name, products[i].price);
    }

    return 0;
}


#include <stdio.h>
#include <string.h>

int main() {
    char str[100];
    char *start, *end, temp;

    scanf("%s", str);

    start = str;
    end = str + strlen(str) - 1;

    while(start < end) {
        temp = *start;
        *start = *end;
        *end = temp;
        start++;
        end--;
    }

    printf("%s", str);
    return 0;
}


#include <stdio.h>
#include <string.h>

struct Hotel {
    char name[50];
    char address[100];
    int grade;
    int rooms;
    float roomCharge;
};

void displayByCharge(struct Hotel h[], int n, float maxCharge) {
    int i;
    for(i = 0; i < n; i++) {
        if(h[i].roomCharge < maxCharge) printf("%s\n", h[i].name);
    }
}

void displayByGrade(struct Hotel h[], int n, int grade) {
    int i;
    for(i = 0; i < n; i++) {
        if(h[i].grade == grade) printf("%s\n", h[i].name);
    }
}

int main() {
    int n, i, grade;
    float maxCharge;
    struct Hotel hotels[100];

    scanf("%d", &n);
    for(i = 0; i < n; i++) {
        scanf("%s %s %d %d %f", hotels[i].name, hotels[i].address,
              &hotels[i].grade, &hotels[i].rooms, &hotels[i].roomCharge);
    }

    scanf("%f", &maxCharge);
    displayByCharge(hotels, n, maxCharge);

    scanf("%d", &grade);
    displayByGrade(hotels, n, grade);

    return 0;
}


#include <stdio.h>

int main() {
    int n1, n2, i, j;
    int arr1[50], arr2[50], merged[100];
    int *ptr = merged, temp;

    scanf("%d", &n1);
    for(i = 0; i < n1; i++) scanf("%d", &arr1[i]);

    scanf("%d", &n2);
    for(i = 0; i < n2; i++) scanf("%d", &arr2[i]);

    for(i = 0; i < n1; i++) *(ptr + i) = arr1[i];
    for(i = 0; i < n2; i++) *(ptr + n1 + i) = arr2[i];

    for(i = 0; i < n1 + n2 - 1; i++) {
        for(j = i + 1; j < n1 + n2; j++) {
            if(*(ptr + i) > *(ptr + j)) {
                temp = *(ptr + i);
                *(ptr + i) = *(ptr + j);
                *(ptr + j) = temp;
            }
        }
    }

    for(i = 0; i < n1 + n2; i++) printf("%d ", *(ptr + i));

    return 0;
}


#include <stdio.h>

int checkPalindrome(int num, int reverse) {
    if(num == 0) return reverse;
    return checkPalindrome(num / 10, reverse * 10 + num % 10);
}

int main() {
    int num;
    scanf("%d", &num);

    if(num == checkPalindrome(num, 0)) printf("Palindrome");
    else printf("Not Palindrome");

    return 0;
}


#include <stdio.h>
#include <string.h>

struct Book {
    char title[50];
    char author[50];
    float price;
};

void applyDiscount(struct Book b, float discount) {
    float finalPrice = b.price - (b.price * discount / 100);
    printf("%.2f", finalPrice);
}

int main() {
    struct Book b;
    float discount;

    scanf("%s %s %f", b.title, b.author, &b.price);
    scanf("%f", &discount);

    applyDiscount(b, discount);

    return 0;
}
