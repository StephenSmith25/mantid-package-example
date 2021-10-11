#include "MantidPrototype/math_functions.h"

namespace MathFunctions{
int nthPrime(int n)
{

    return boost::math::prime(n);

}
}