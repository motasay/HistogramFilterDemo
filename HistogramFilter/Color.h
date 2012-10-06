#define MAX_NUM_OF_COLORS 6

#define BeliefColor [UIColor whiteColor]

#define MaxBeliefColor [UIColor redColor]

typedef enum {Gray, Blue, Black, Orange, Green, Brown} ColorName;

typedef struct Color {
   ColorName name;
   short red;
   short green;
   short blue;
} CColor;