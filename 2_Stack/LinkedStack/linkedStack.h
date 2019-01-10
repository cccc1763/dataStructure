#pragma once
#include <iostream>
using namespace std;

typedef struct tagNode{
	int value;
	struct tagNode* nextNode;
}NODE;

typedef struct tagLinkedStack{
	tagNode* topNode;
	int iTOS;
}LINKED_STACK;

void CreateStack(LINKED_STACK** Stack);
void DestroyStack(LINKED_STACK* Stack);
void Push(LINKED_STACK* Stack, int value);
void Pop(LINKED_STACK* Stack);