module timing;

import std.stdio, std.file, std.csv, std.range;

import common;
import dumbknn;
import bucketknn;
import kdtree;
import quadtree;

static const int dimensionQuantity = 30;
static const int kQuantity = 30;
static const int numberQuantity = 50;
static const int iterations = 10;

/*

void kDumbKNNTiming()
{
    File file = File("analysis/KDumbKNN.csv", "w");
    file.write("Index");
    foreach (index; 1 .. kQuantity + 1)
    {
        file.write(", ", index);
    }

    file.write("\nK");
    foreach (k; 1 .. kQuantity + 1)
    {
        file.write(", ", k * 10);
    }

    file.write("\nTime");
    static foreach (k; 1 .. kQuantity + 1)
    {
        {
            auto trainingPoints = getGaussianPoints!10(10_000);
            auto testingPoints = getUniformPoints!10(100);
            auto kd = DumbKNN!10(trainingPoints);
            StopWatch sw;
            sw.start;

            for (int i = 0; i < iterations; i++)
            {
                foreach (const ref qp; testingPoints)
                {
                    kd.knnQuery(qp, k * 10);
                }
            }
            file.write(", ", sw.peek.total!"usecs" / iterations);
            file.flush();
        }
    }
}


void nDumbKNNTiming()
{

    File file = File("analysis/nDumbKNN.csv", "w");
    file.write("Index");
    foreach (index; 1 .. numberQuantity + 1)
    {
        file.write(", ", index);
    }

    file.write("\nN");
    foreach (dim; 1 .. numberQuantity + 1)
    {
        file.write(", ", dim * 1000);
    }

    file.write("\nTime");
    static foreach (n; 1 .. numberQuantity + 1)
    {
        {
            auto trainingPoints = getGaussianPoints!10(n * 1000);
            auto testingPoints = getUniformPoints!10(100);
            auto kd = DumbKNN!10(trainingPoints);
            StopWatch sw;
            sw.start;

            for (int i = 0; i < iterations; i++)
            {
                foreach (const ref qp; testingPoints)
                {
                    kd.knnQuery(qp, 10);
                }
            }
            file.write(", ", sw.peek.total!"usecs" / iterations);
            file.flush();
        }
    }
}




void dimensionDumbKNNTiming()
{
    File file = File("analysis/DimensionDumbKNN.csv", "w");
    file.write("Index");
    foreach (index; 1 .. dimensionQuantity + 1)

    {
        file.write(", ", index);
    }

    file.write("\nDimension");
    foreach (dim; 1 .. dimensionQuantity + 1)

    {
        file.write(", ", dim);
    }

    file.write("\nTime");
    static foreach (dim; 1 .. dimensionQuantity + 1)
    {
        {
            //get points of the appropriate dimension
            auto trainingPoints = getGaussianPoints!dim(10_000);
            auto testingPoints = getUniformPoints!dim(100);
            auto kd = DumbKNN!dim(trainingPoints);
            StopWatch sw;
            sw.start;

            for (int i = 0; i < iterations; i++)
            {
                foreach (const ref qp; testingPoints)
                {
                    kd.knnQuery(qp, 10);
                }
            }
            file.write(", ", sw.peek.total!"usecs" / iterations);
            file.flush();
        }
    }
}



void kBucketKNNTiming()
{
    File file = File("analysis/KBucketKNN.csv", "w");
    file.write("Index");
    foreach (index; 1 .. kQuantity + 1)
    {
        file.write(", ", index);
    }

    file.write("\nK");
    foreach (k; 1 .. kQuantity + 1)
    {
        file.write(", ", k * 10);
    }
    file.write("\nTime");
    static foreach (k; 1 .. kQuantity + 1)
    {
        {
            auto trainingPoints = getGaussianPoints!8(10_000);
            auto testingPoints = getUniformPoints!8(100);
            auto kd = BucketKNN!8(trainingPoints);
            StopWatch sw;
            sw.start;

            for (int i = 0; i < iterations; i++)
            {
                foreach (const ref qp; testingPoints)
                {
                    kd.knnQuery(qp, k * 10);
                }
            }
            file.write(", ", sw.peek.total!"usecs" / iterations);
            file.flush();
        }
    }
}

void nBucketKNNTiming()
{
    File file = File("analysis/nBucketKNN.csv", "w");
    file.write("Index");
    foreach (index; 1 .. numberQuantity + 1)
    {
        file.write(", ", index);
    }

    file.write("\nN");
    foreach (dim; 1 .. numberQuantity + 1)
    {
        file.write(", ", dim * 1000);
    }

    file.write("\nTime");
    static foreach (n; 1 .. numberQuantity + 1)
    {
        {
            //get points of the appropriate dimension
            auto trainingPoints = getGaussianPoints!4(n * 1000);
            auto testingPoints = getUniformPoints!4(100);
            auto kd = BucketKNN!4(trainingPoints);
            StopWatch sw;
            sw.start;

            for (int i = 0; i < iterations; i++)
            {
                foreach (const ref qp; testingPoints)
                {
                    kd.knnQuery(qp, 10);
                }
            }
            file.write(", ", sw.peek.total!"usecs" / iterations);
            file.flush();
        }
    }
}



void dimensionBucketKNNTiming()
{
    File file = File("analysis/DimensionBucketKNN.csv", "w");
    file.write("Index");
    foreach (index; 1 .. 20 + 1)
    {
        file.write(", ", index);
    }

    file.write("\nDimension");
    foreach (dim; 1 .. 20 + 1)
    {
        file.write(", ", dim);
    }

    file.write("\nTime");
    static foreach (dim; 1 .. 20 + 1)
    {
        {
            //get points of the appropriate dimension
            auto trainingPoints = getGaussianPoints!dim(10_000);
            auto testingPoints = getUniformPoints!dim(100);
            auto kd = BucketKNN!dim(trainingPoints);
            StopWatch sw;
            sw.start;

            for (int i = 0; i < iterations; i++)
            {
                foreach (const ref qp; testingPoints)
                {
                    kd.knnQuery(qp, 10);
                }
            }
            file.write(", ", sw.peek.total!"usecs" / iterations);
            file.flush();
        }
    }
}



void kQuadTreeKNNTiming()
{

    File file = File("analysis/KQuadTreeKNN.csv", "w");
    file.write("Index");
    foreach (index; 1 .. kQuantity + 1)
    {
        file.write(", ", index);
    }

    file.write("\nK");
    foreach (k; 1 .. kQuantity + 1)
    {
        file.write(", ", k*10);
    }

    file.write("\nTime");
    static foreach (k; 1 .. kQuantity + 1)
    {
        {
            //get points of the appropriate dimension
            auto trainingPoints = getGaussianPoints!2(10_000);
            auto testingPoints = getUniformPoints!2(100);
            auto kd = QuadTree(trainingPoints);
            StopWatch sw;
            sw.start;

            for (int i = 0; i < iterations; i++)
            {
                foreach (const ref qp; testingPoints)
                {
                    kd.knnQuery(qp, k*10);
                }
            }
            file.write(", ", sw.peek.total!"usecs" / iterations);
            file.flush();
        }
    }
}

void nQuadTreeKNNTiming()
{

    File file = File("analysis/nQuadTreeKNN.csv", "w");
    file.write("Index");
    foreach (index; 1 .. numberQuantity + 1)
    {
        file.write(", ", index);
    }

    file.write("\nN");
    foreach (n; 1 .. numberQuantity + 1)
    {
        file.write(", ", n * 1000);
    }

    file.write("\nTime");
    static foreach (n; 1 .. numberQuantity + 1)
    {
        {
            //get points of the appropriate dimension
            auto trainingPoints = getGaussianPoints!2(n * 1000);
            auto testingPoints = getUniformPoints!2(100);
            auto kd = QuadTree(trainingPoints);
            StopWatch sw;
            sw.start;

            for (int i = 0; i < iterations; i++)
            {
                foreach (const ref qp; testingPoints)
                {
                    kd.knnQuery(qp, 10);
                }
            }
            file.write(", ", sw.peek.total!"usecs" / iterations);
            file.flush();
        }
    }
}
*/


void kKDTreeKNNTiming()
{

    File file = File("analysis/KKDTreeKNN.csv", "w");
    file.write("Index");
    foreach (index; 1 .. kQuantity + 1)
    {
        file.write(", ", index);
    }

    file.write("\nK");
    static foreach (k; 1 .. kQuantity + 1)
    {
        file.write(", ", k*10);
    }

    file.write("\nTime");
    static foreach (k; 1 .. kQuantity + 1)
    {
        {
            //get points of the appropriate dimension
            auto trainingPoints = getGaussianPoints!10(10_000);
            auto testingPoints = getUniformPoints!10(100);
            auto kd = KDTree!10(trainingPoints);
            StopWatch sw;
            sw.start;

            for (int i = 0; i < iterations; i++)
            {
                foreach (const ref qp; testingPoints)
                {
                    kd.knnQuery(qp, k*10);
                }
            }
            file.write(", ", sw.peek.total!"usecs" / iterations);
            file.flush();
        }
    }
}

void nKDTreeKNNTiming()
{

    File file = File("analysis/nKDTreeKNN.csv", "w");
    file.write("Index");
    foreach (index; 1 .. numberQuantity + 1)
    {
        file.write(", ", index);
    }

    file.write("\nN");
    foreach (dim; 1 .. numberQuantity + 1)
    {
        file.write(", ", dim * 1000);
    }

    file.write("\nTime");
    static foreach (n; 1 .. numberQuantity + 1)
    {
        {
            //get points of the appropriate dimension
            auto trainingPoints = getGaussianPoints!10(n * 1000);
            auto testingPoints = getUniformPoints!10(100);
            auto kd = KDTree!10(trainingPoints);
            StopWatch sw;
            sw.start;

            for (int i = 0; i < iterations; i++)
            {
                foreach (const ref qp; testingPoints)
                {
                    kd.knnQuery(qp, 10);
                }
            }
            file.write(", ", sw.peek.total!"usecs" / iterations);
            file.flush();
        }
    }
}

void dimensionKDTreeKNNTiming()
{
    File file = File("analysis/DimensionKDTreeKNN.csv", "w");
    file.write("Index");
    foreach (index; 1 .. dimensionQuantity + 1)
    {
        file.write(", ", index);
    }

    file.write("\nDimension");
    foreach (dim; 1 .. dimensionQuantity + 1)
    {
        file.write(", ", dim);
    }

    file.write("\nTime");
    static foreach (dim; 1 .. dimensionQuantity + 1)
    {
        {
            //get points of the appropriate dimension
            auto trainingPoints = getGaussianPoints!dim(10_000);
            auto testingPoints = getUniformPoints!dim(100);
            auto kd = KDTree!dim(trainingPoints);
            StopWatch sw;
            sw.start;

            for (int i = 0; i < iterations; i++)
            {
                foreach (const ref qp; testingPoints)
                {
                    kd.knnQuery(qp, 10);
                }
            }
            file.write(", ", sw.peek.total!"usecs" / iterations);
            file.flush();
        }
    }
}
/*
*/
