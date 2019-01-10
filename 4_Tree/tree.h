#pragma once
#include <stdio.h>
#include <stdlib.h>

typedef struct tagTree {
	struct tagNode* topNode;
	int cnt;
}TREE;

typedef struct tagNode {
	struct tagNode* leftChild;
	struct tagNode* rightSibling;
	int data;
}NODE;

void createTree(TREE** Tree, int topData);
void destroyTree(NODE* N);
void insertChildNode(NODE* parentNode, int data);
void insertSiblingNode(NODE* ptingNode, int data);
void deleteNode(NODE* N);