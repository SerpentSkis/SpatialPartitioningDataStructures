//          Copyright chadhurst 2020. 
// Distributed under the Boost Software License, Version 1.0. 
//    (See accompanying file LICENSE_1_0.txt or copy at 
//          http://www.boost.org/LICENSE_1_0.txt)} 

module quadtree;

import common;
import std.math;

public static int THRESH_HOLD = 4;
struct QuadTree
{
    Node root;
    Point!2[] points;

    this(Point!2[] points)
    {
        root = new Node(points);
        this.points = points;
    }

    class Node
    {
        bool isLeaf = true;
        Point!2[] bucket;
        Node northEast, northWest, southEast, southWest;
        AABB!2 bounds;

        this(Point!2[] points)
        {
            bounds = boundingBox(points);
            if (points.length < THRESH_HOLD)
            {
                isLeaf = true;
                bucket = points;
            }
            else
            {
                isLeaf = false;
                Point!2 midPoint = (bounds.min + bounds.max) / 2;

                Point!2[] rightHalf = points.partitionByDimension!0(midPoint[0]);
                Point!2[] leftHalf = points[0 .. $ - rightHalf.length];

                Point!2[] topLeft = leftHalf.partitionByDimension!1(midPoint[1]);
                Point!2[] bottomLeft = leftHalf[0 .. $ - topLeft.length];

                Point!2[] topRight = rightHalf.partitionByDimension!1(midPoint[1]);
                Point!2[] bottomRight = rightHalf[0 .. $ - topRight.length];

                northEast = new Node(topRight);
                northWest = new Node(topLeft);
                southEast = new Node(bottomRight);
                southWest = new Node(bottomLeft);
            }
        }
    }

    /// return all points within a distance radius of pointOfInterest
    Point!2[] rangeQuery(Point!2 pointOfInterest, float radius)
    {
        Point!2[] ret;
        void recurse(Node node)
        {
            if (node.isLeaf)
            {
                foreach (point; node.bucket)
                {
                    if (distance(point, pointOfInterest) < radius)
                    {
                        ret ~= point;
                    }
                }
            }
            else if (distance(pointOfInterest, closest(node.bounds, pointOfInterest)) < radius)
            {
                recurse(node.northEast);
                recurse(node.northWest);
                recurse(node.southEast);
                recurse(node.southWest);
            }
        }

        recurse(root);
        return ret;
    }

    /// return the k points closest to p
    Point!2[] knnQuery(Point!2 pointOfInterest, int k)
    {
        if (points.length <= k)
        {
            return points;
        }
        auto priorityQueue = makePriorityQueue(pointOfInterest);
        void recurse(Node node, float radius)
        {
            if (node.isLeaf)
            {
                foreach (pointInBucket; node.bucket)
                {
                    if (distance(pointInBucket, pointOfInterest) < radius)
                    {
                        if (priorityQueue.length < k)
                        {
                            priorityQueue.insert(pointInBucket);
                        }
                        else if (distance(priorityQueue.front,
                                pointOfInterest) > distance(pointInBucket, pointOfInterest))
                        {
                            priorityQueue.popFront();
                            priorityQueue.insert(pointInBucket);
                        }
                    }
                }
            }
            else if (priorityQueue.length == 0 || distance(pointOfInterest, closest(node.bounds,
                    pointOfInterest)) < distance(pointOfInterest, priorityQueue.front))
            {
                recurse(node.northEast, radius);
                recurse(node.northWest, radius);
                recurse(node.southEast, radius);
                recurse(node.southWest, radius);
            }
        }

        ///tweak r
        float radius = 1;
        while (priorityQueue.length < k)
        {
            //TOOD do I need to reset pq?
            recurse(root, radius *= 2);
        }

        return priorityQueue.release();
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
    QuadTree quadTree = QuadTree(points);

    writeln("quadTree rq");
    foreach (point; quadTree.rangeQuery(Point!2([1, 1]), .7))
    {
        writeln(point);
    }

    writeln("quadTree knn");
    foreach (p; quadTree.knnQuery(Point!2([1, 1]), 3))
    {
        writeln(p);
    }
}
