#pragma once
#include <iostream>
using namespace std;

typedef struct tagNode {
	int value;
	struct tagNode* next;
}NODE;

typedef struct tagLinkedQueue {
	NODE* front;
	NODE* rear;
	int cnt;
}LQueue;

void LQ_CreateQueue(LQueue** Queue);
void LQ_DestroyQueue(LQueue* Queue);
void LQ_Enqueue(LQueue* Queue, NODE* n);
void LQ_Dequeue(LQueue* Queue);