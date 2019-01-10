#pragma once
#include <iostream>
using namespace std;

typedef struct tagNode {
	int value;
}NODE;

typedef struct tagCircularQueue {
	int cap;
	int front;
	int rear;
	NODE* NodeArr;
}CQueue;

void CQ_CreateQueue(CQueue** Queue, int cap);
void CQ_DestroyQueue(CQueue* Queue);
void CQ_Enqueue(CQueue* Queue, int value);
int CQ_Dequeue(CQueue* Queue);
int CQ_isEmpty(CQueue* Queue);
int CQ_isFull(CQueue* Queue);