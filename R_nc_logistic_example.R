m_sigmoid = function(x)
{
  return(1 / (1 + exp(-x)))
}

x = c()
y = c()
# Synthetic Bernoulli Data
for (i in 1:1000)
{
  x[i] = rnorm(1, mean = 0, sd = 2)
  y[i] = ifelse(m_sigmoid(x[i] * 0.2 + rnorm(1, 0, sd = 0.2)) > 0.5, 1, 0)
}

linmoid = function(b0, b1, x)
{
  eval = b0 + b1*x
  eval = ifelse(eval > 1, 1, eval)
  eval = ifelse(eval < 0, 0, eval)
  return(eval)
}

# non-cononical logistic regression (linmoid model)
sourceCpp("nc_logistic.cpp")
model = nc_logistic(x, y, iter = 100000)
bet0 = model[1]
bet1 = model[2]

# R GLM model
mdl = glm(y ~ x, family = "binomial")
summary(mdl)

library(caret)
custom_preds = ifelse(linmoid(bet0, bet1, x) > 0.5, 1, 0)
r_preds = ifelse(predict(mdl, type = "response") > 0.5, 1, 0)
confusionMatrix(as.factor(y), as.factor(custom_preds))
confusionMatrix(as.factor(y), as.factor(r_preds))

# visualize "linmoid"
plot(x, y, main = "linmoid model")
xv = seq(-6, 6, 0.001)
yv = bet0 + bet1*xv
yv = ifelse(yv > 1, 1, yv)
yv = ifelse(yv < 0, 0, yv)
lines(xv, yv, lwd = 3, col=c("red"))
