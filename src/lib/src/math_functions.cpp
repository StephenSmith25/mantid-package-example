#include "MantidPrototype/math_functions.h"

namespace MathFunctions{
double nThPrime(int n)
{

    return boost::math::prime(n);

}
}