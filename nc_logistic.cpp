#include <Rcpp.h>
#include <math.h>
using namespace Rcpp;

double b0_grad(double b0, double b1, double x, int y)
{
  return (y / ((b0 + b1*x)+0.01)) + ((y - 1) / ((1 - b0 - b1*x)+0.01));
}

double b1_grad(double b0, double b1, double x, int y)
{
  return (y*x / ((b0 + b1*x))+0.01) + ((y - 1)*x / ((1 - b0 - b1*x)+0.01));
}

// [[Rcpp::export]]
NumericVector nc_logistic(
    NumericVector const& x, 
    NumericVector const& y, 
    R_xlen_t iter = 1000, 
    double learning_rate = 0.0001
)
{
  double bet0 = 1.0;
  double bet1 = 1.0;
  
  double bet0_t, bet1_t;
  
  for (unsigned int i = 0; i < iter; ++i)
  {
    for (R_xlen_t idx = 0; idx < x.size(); ++idx)
    {
      bet0_t = bet0 + b0_grad(bet0, bet1, x[idx], y[idx]) * learning_rate;
      bet1_t = bet1 + b1_grad(bet0, bet1, x[idx], y[idx]) * learning_rate;
      
      if (bet1_t < 0) { bet1_t = 0.01; }
      
      bet0 = bet0_t;
      bet1 = bet1_t;
    }
  }
  
  NumericVector coefficients = { bet0, bet1 };
  return coefficients;
}
