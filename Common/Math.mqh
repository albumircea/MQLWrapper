//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2020, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+




//#include <_profitpoint/Mql/MqlInfo>

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CMath
  {
public:
   static int                    RandomInteger(const int min = 0, const int max = 32768);
   static double                 RandomDouble(const double min, const double max);
   template<typename T>
   static T                      Max(T value1, T value2) {return value1 > value2 ? value1 : value2;}


   template<typename T>
   static T                      Min(T value1, T value2) {return value1 < value2 ? value1 : value2;}

   template<typename T>
   static T                      Abs(T value)            {return value < 0 ? -value : value;}

   template<typename T>
   static int                    Sign(T value)           {return value < 0 ? -1 : 1;}

   template<typename T>
   static bool                   IsEqual(T a, T b) {return NormalizeDouble(a - b, 8) == 0;}

   static double                 RoundUpToMultiple(double value, double min);
   static double                 RoundDownToMultiple(double value, double min);
   static double                 RoundUpToStep(double value, double min, double step);
   static double                 RoundDownToStep(double value, double min, double step);



  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
static int CMath::RandomInteger(const int min = 0, const int max = 32768)
  {
   int RAND_MAX = INT_MAX;
   int range = max - min;
   if(range > RAND_MAX)
      range = RAND_MAX;
   int randMin = RAND_MAX % range;
   int random;
   do
     {
      random = MathRand();
     }
   while(random <= randMin);
   return random % range + min;
  }

//+------------------------------------------------------------------+
static double CMath::RandomDouble(const double min, const double max)
  {
   double f   = (MathRand() / 32768.0);
   return min + (int)(f * (max - min));

  }
//+------------------------------------------------------------------+
static double CMath::RoundUpToMultiple(double value, double min)
  {
   int n = (int)MathRound(value / min);
   return IsEqual(n * min, value) ? n * min : ((int)(value / min) + 1) * min;
  }

//--- round value down to a multiple of min
static double CMath::RoundDownToMultiple(double value, double min)
  {
   int n = (int)MathRound(value / min);
   return IsEqual(n * min, value) ? n * min : (int)(value / min) * min;
  }

//--- round value up to a min+multiple*step
static double CMath::RoundUpToStep(double value, double min, double step)
  {
   value -= min;
   int n = (int)MathRound(value / step);
   if(!IsEqual(n * step, value))
      n = (int)(value / step) + 1;
   return n * step + min;
  }

//--- round value down to a min+multiple*step
static double CMath::RoundDownToStep(double value, double min, double step)
  {
   value -= min;
   int n = (int)MathRound(value / step);
   if(!IsEqual(n * step, value))
      n = (int)(value / step);
   return n * step + min;
  }
//+------------------------------------------------------------------+