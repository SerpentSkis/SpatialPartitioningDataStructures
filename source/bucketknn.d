//          Copyright chadhurst 2020. 
// Distributed under the Boost Software License, Version 1.0. 
//    (See accompanying file LICENSE_1_0.txt or copy at 
//          http://www.boost.org/LICENSE_1_0.txt)} 

module bucketknn;

import common;
import std.math;

struct BucketKNN(size_t Dim)
{
    alias Bucket = Point!Dim[];

    Point!Dim[] points;
    AABB!Dim aabb;
    Bucket[] buckets;
    Point!Dim spatialSize;
    Point!Dim minCorner; // You'll use this and the bucket size to find out which bucket a point would go in
    ulong splitsPerDimension; // the number of splits/divisions along each dimension

    this(Point!Dim[] points)
    {
        this.points = points.dup;
        //we want the average number of points in each bucket to be around 64
        //64 = points.length/(splits^dim)
        //splits^dim = points.length/64
        //splits = (points.length/64)^(1/dim)
        splitsPerDimension = cast(ulong) pow((1.0 * points.length) / 64, 1 / (1.0 * Dim));
        aabb = boundingBox(points);
        minCorner = aabb.min;
        spatialSize = (aabb.max - aabb.min) / (cast(float) splitsPerDimension);

        buckets = new Bucket[cast(ulong) pow(splitsPerDimension, Dim)];

        foreach (Point!Dim point; points)
        {
            buckets[getBucketIndex(getBucketCoords(point))] ~= point;
        }
    }

    Indices!Dim getBucketCoords(Point!Dim point)
    {
        Indices!Dim coords;

        for (int i = 0; i < Dim; i++)
        {
            coords[i] = clamp(cast(int)((point[i] - this.minCorner[i]) / this.spatialSize[i]),
                    0, splitsPerDimension - 1);
        }

        return coords;
    }

    ulong getBucketIndex(Indices!Dim coords)
    {
        ulong index = 0;

        for (int i = 0; i < Dim; i++)
        {
            index += coords[i] * pow(splitsPerDimension, Dim - i - 1);
        }

        return index;
    }

    /// return all points within a distance radius of pointOfInterest
    Point!Dim[] rangeQuery(Point!Dim pointOfInterest, float radius)
    {
        Point!Dim[] ret;

        foreach (ind; getIndicesRange(getBucketCoords(pointOfInterest - radius),
                getBucketCoords(pointOfInterest + radius)))
        {
            foreach (point; buckets[getBucketIndex(ind)])
            {
                if (distance(point, pointOfInterest) < radius)
                {
                    ret ~= point;
                }
            }
        }
        return ret;
    }

    /// return the k points closest to pointOfInterest
    Point!Dim[] knnQuery(Point!Dim pointOfInterest, int k)
    {
        if (points.length <= k)
        {
            return points;
        }

        Point!Dim zeroPoint = spatialSize - spatialSize;
        float radius = distance(zeroPoint, spatialSize);
        Point!Dim[] rq = rangeQuery(pointOfInterest, radius);
        while (rq.length < k)
        {
            ///tweakable
            radius *= 1.5;
            rq = rangeQuery(pointOfInterest, radius);
        }

        rq.topNByDistance(pointOfInterest, k);
        return rq[0 .. k].dup;

    }
}

unittest
{
    //I'd include unitttesting code for each of your data structures to test with
    //use a small # of points and manually check that you get the answers you expect
    Point!2[] points = [
        Point!2([.5, .5]), Point!2([1, 1]), Point!2([0.75, 0.4]),
        Point!2([0.4, 0.74])
    ];
    //since the points are 2D, the data structure is a DumbKNN!2
    BucketKNN!2 bucketKNN = BucketKNN!2(points);

    writeln("bucketKNN rq");
    foreach (p; bucketKNN.rangeQuery(Point!2([1, 1]), .7))
    {
        writeln(p);
    }

    writeln("bucketKNN knn");
    foreach (p; bucketKNN.knnQuery(Point!2([1, 1]), 3))
    {
        writeln(p);
    }
}
