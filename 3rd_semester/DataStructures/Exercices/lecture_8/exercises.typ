#import "@preview/codly:1.2.0": *
#import "@preview/codly-languages:0.1.1": *
#show: codly-init.with()

#codly(languages: codly-languages)
#set page(numbering: "1")

#align(center, text(20pt)[
  Lecture 7 Exercises
])

#align(center, text(15pt)[
  Arthur Rabello Oliveira\
  #datetime.today().display("[day]/[month]/[year]")
])

= Exercise 1
== Solution
=== a)

It is clear that:

$
  T_1 in O(n)
$

$
  T_2 in O(n²)
$

Given the proper definition of the function class $O(g)$ ("Big O") of a function $g:NN -> RR$ as follows;

$
  O(g) := {f:NN -> RR | exists c in RR, n_0 in NN, f(n) <= c g(n), forall n > n_0}
$

=== b)

We assume $n != 0$ , for obviously $T_1(0) = T_2(0)$, so $T_2$ is more efficient if:

$
  T_1(n) > T_2(n) <=> 625n > n² <=> 625 > n
$

And the opposite is true for $625 < n$ , for $n = 625$ the algorithms perform equally.

= Exercise 2
== Solution

Algorithms $T_1, ... , T_5, T_7 , ... ,T_9$ are trivial. for $T_6$, if $n>1$ then $T_6 in O(n log²(n))$. For $T_10$, notice that:

$
  T(2) = 2 T(1) + 2 in O(1),
$

$
  T(3) = 2 T(2) + 2 = 2 [2 T(1) + 2] + 2
$

$
  .
$

$
  .
$

$
  .
$

$
  T(n) = 2^n [T(1) + 1] + 2 in O(2^n).
$

= Exercise 3
== Solution
=== a)

```cpp
int a = 0, b = 0;
for (i = 0; i < n; i++) {
    a = a + i;
}
for (j = 0; j < m; j++) {
    b = b + j;
}
```

The algorithm operates in $O(n) + O(m)$, the first ``` for ``` grows linearly with $n$ and the second one grows with $m$.

=== b)

```cpp
float what2(int *arr, int n) {
    int a = 0;
    for (int i = 0; i < n; i++) {
        if(arr[i] > 10) {
            for (int j = 0; j < n; j++) {
                a += n / 2;
            }
        } else {
            printf("ok :(")
        }
    }
}
```

The algorithm has 2  ``` for's ``` with n operations each in a worst-case scenario, therefore it is precisely $in O(n²)$.

=== c)

```cpp
int a = 0;
for (int i = 0; i < n; i++) {
    for (int j = n; j > i; j--) {
        a += i + j;
    }
}
```

For $i = 0$ , $j$ goes from $n$ to 0, and the operation a += n/2 is executed $n$ times, for $i = 1$ , $n$ goes from $n$ to 1 and the operation is executed $n-1$ times and so on, so we have:

$
  sum_(i=1)^(n-1) n-i = n(n+1) / 2
$

So the algorithm is $in O(n²)$. 

=== d)

```cpp
float what4(int *arr, int n) {
    int a = 0;
    for (int i = 0; i < 1000; i++) {
        for (int j = 0; j < 5000; j++) {
            a += i + j;
        }
    }
}
```

Both loops have constant limits, so the total complexity is $O(1)$.

=== e)

```cpp
int a = 0;
for (int i = n/2; i <= n; i++) {
    for (int j = 2; j <= n; j = j * 2) {
        a += i + j;
    }
}
```

The external loop executes $O(n)$ times, and the internal one $O(log n)$. So the total complexity is $O(n log n)$.

=== f)

```cpp
int a = 0, i = n;
while (i > 0) {
    a += i;
    i /= 2;
}
```
At each iteration, i is divided by 2: i = n, n/2, n/4, $dots$, 1.

This loop executes $log_2 n$ times, and each step does constant work.

Therefore, the time complexity is:

$
  O(log_2 n)
$

=== g)

 ```cpp
int a = 0, i = n;
while (i > 0) {
    for (int j = 0; j < i; j++) {
        a += i;
    }
    i /= 2;
}
 ```

At each iteration of the while, the value of i is divided by 2. In the first iteration, the for executes n times, then n/2, n/4, ..., until i = 1. The total sum of operations is:

$ T(n) = n + n/2 + n/4 + ... + 1 = 2n - 1 \in O(n) $

Therefore, the time complexity of the algorithm is $O(n)$.

 === h)

```cpp
float soma(float *arr, int n) {
    float total = 0;
    for (int i = 0; i < n; i++) {
        total += arr[i];
    }
    return total;
}
```

The algorithm traverses the array of size $n$ once, performing one addition per element. Therefore, its complexity is linear: $O(n)$.

=== i)

```cpp
int buscaSequencial(int *arr, int n, int x) {
    for (int i = 0; i < n; i++){
        if (arr[i] == x) {
            return i;
        }
    }
    return -1;
}
```

In the worst case (when $x$ is not in the array), the algorithm goes through all $n$ elements. Thus, its worst-case complexity is $O(n)$.

==== j)

```cpp
int buscaBinaria(int *arr, int x, int i, int j) {
    if (i >= j) {
        return ‐1;
    }

    int m = (i + j) / 2;
    if (arr[m] == x) {
        return m;
    } else if ( x < arr[m] ) {
        return buscaBinaria (arr, x, i, m‐1);
    } else {
        return buscaBinaria (arr, x, m+1, j);
    }
}
```

At each recursive call the search space is halved. Thus, the worst-case complexity of binary search is $O(log_2 n)$.

==== k)

```cpp
void multiplicacaiMatriz(float **a, float **b, int n, int p, int m, float **x) {
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < m; j++) {
            x[i][j] = 0.0;
            for (int k = 0; k < p; k++) {
                x[i][j] += a[i][k] * b[k][j];
            }
        }
    }
}
```

The multiplication of matrices of dimensions $n p$ by $p m$ performs $n m p$ multiplications. Therefore, the complexity is $O(n m p)$.

= Exercise 4
== Solution

Currently empty. We encourage the reader (me lol) to do this as homework.