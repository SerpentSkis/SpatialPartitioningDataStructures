//          Copyright chadhurst 2020. 
// Distributed under the Boost Software License, Version 1.0. 
//    (See accompanying file LICENSE_1_0.txt or copy at 
//          http://www.boost.org/LICENSE_1_0.txt)} 

module kdtree;

import common;
import std.math;

struct KDTree(size_t Dim)
{
    //todo member variables

    Node!0 root;
    Point!Dim[] allPoints;

    this(Point!Dim[] allPoints)
    {
        root = new Node!0(allPoints);
        this.allPoints = allPoints;
    }

    //An x-split node and a y-split node are different types
    class Node(size_t splitDimension)
    {
        Point!Dim splitPoint;

        //if this is an x node, the next level is "y"
        //if this is a y node, the next level is "z", etc
        enum thisLevel = splitDimension; //this lets you refer to a node's split level with theNode.thisLevel
        enum nextLevel = (splitDimension + 1) % Dim;
        Node!nextLevel left, right; //child nodes split by the next level
        Point!Dim[] nodePoints;

        this(Point!Dim[] nodePoints)
        {
            this.nodePoints = nodePoints;
            nodePoints.medianByDimension!thisLevel;
            assert(nodePoints.length != 0);
            if (nodePoints.length == 1)
            {
                left = null;
                splitPoint = nodePoints[0];
                right = null;
                return;
            }
            if (nodePoints.length == 2)
            {
                left = new Node!nextLevel(nodePoints[0 .. 1]);
                splitPoint = nodePoints[1];
                right = null;
                return;
            }

            left = new Node!nextLevel(nodePoints[0 .. $ / 2]);
            splitPoint = nodePoints[$ / 2];
            right = new Node!nextLevel(nodePoints[$ / 2 + 1 .. $]);
        }

    }

    Point!Dim[] rangeQuery(Point!Dim pointOfInterest, float radius)
    {
        return rangeQuery(this.root, pointOfInterest, radius);
    }

    /// return all points within a distance r of p
    Point!Dim[] rangeQuery(NodeType)(NodeType node, Point!Dim pointOfInterest, float radius)
    {
        Point!Dim[] ret;

        void recurse(NodeType)(NodeType node)
        {
            if (distance(node.splitPoint, pointOfInterest) < radius)
            {
                ret ~= node.splitPoint;
            }

            if (node.left !is null)
            {
                recurse(node.left);
            }
            if (node.right !is null)
            {
                recurse(node.right);
            }
        }

        recurse(root);
        return ret;
    }

    ///driver method
    Point!Dim[] knnQuery(Point!Dim pointOfInterest, int k)
    {
        if (allPoints.length <= k)
        {
            return allPoints;
        }
        return knnQuery(this.root, pointOfInterest, k);
    }

    /// return the k points closest to p
    Point!Dim[] knnQuery(NodeType)(NodeType node, Point!Dim pointOfInterest, int k)
    {
        auto priorityQueue = makePriorityQueue(pointOfInterest);
        void recurse(NodeType)(NodeType node)
        {
            if (priorityQueue.length < k)
            {
                priorityQueue.insert(node.splitPoint);
            }
            else if (distance(node.splitPoint,
                    pointOfInterest) < distance(priorityQueue.front, pointOfInterest))
            {
                priorityQueue.popFront();
                priorityQueue.insert(node.splitPoint);
            }

            if (node.left !is null && (priorityQueue.length < k || distance(pointOfInterest,
                    closest(boundingBox(node.left.nodePoints), pointOfInterest)) < distance(pointOfInterest,
                    priorityQueue.front)))
            {
                recurse(node.left);
            }

            if (node.right !is null && (priorityQueue.length < k || distance(pointOfInterest,
                    closest(boundingBox(node.right.nodePoints), pointOfInterest)) < distance(pointOfInterest,
                    priorityQueue.front)))
            {
                recurse(node.right);
            }
        }

        recurse(root);
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

    KDTree!2 kdTree = KDTree!2(points);

    writeln("kdTree rq");
    foreach (point; kdTree.rangeQuery(Point!2([1, 1]), .7))
    {
        writeln(point);
    }

    writeln("kdTree knn");
    foreach (point; kdTree.knnQuery(Point!2([1, 1]), 3))
    {
        writeln(point);
    }
}
