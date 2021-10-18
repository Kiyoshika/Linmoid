# Linmoid
A linear approximation to sigmoid for logistic regression (non-canonical link function)

## Mathematics
Typically the link function used for logistic regression is sigmoid. However, to simplify the calculus I am using a raw linear combination and truncating it afterwards.

NOTE: during optimization, I am constraining the slope to be strictly positive otherwise you get weird behavior when making predictions.

```
L(y) = y*log(t) + (1 - y)*log(1 - t)

// our link function is a raw linear combination: b0 + b1*x

L(y) = y*log(b0 + b1*x) + (1 - y)*log(1 - b0 - b1*x)

dL(y) / db0 = (y / (b0 + b1*x)) + ((y - 1) / (1 - b0 - b1*x))

dL(y) / db1 = (x*y / (b0 + b1*x)) + (x*(y - 1) / (1 - b0 - b1*x))

// linmoid

Let f(b0, b1, x) be the linear combination b0 + b1*x

Linmoid(b0, b1, x) = {
    1 if f(b0, b1, x) > 1,
    0 if f(b0, b1, x) < 0
    f(b0, b1, x) otherwise
  }
```

## Optimization
I use a simple gradient ascent optimization to maximize the log likelihood with respect to each coefficient.

As mentioned, I constrain the slope to be strictly positive to avoid weird behavior.

## Visualization
See [this image](linmoid.pdf) for a visualization exported from R (located within the repo).
