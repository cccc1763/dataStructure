#include "tree.h"

// 트리 생성.
void createTree(TREE** Tree, int topData) {
	(*Tree) = (TREE*)malloc(sizeof(TREE));
	(*Tree)->topNode = (NODE*)malloc(sizeof(NODE));
	(*Tree)->topNode->data = topData;
	(*Tree)->topNode->leftChild = NULL;
	(*Tree)->topNode->rightSibling = NULL;
}

// 트리 제거. 재귀함수 사용
void destroyTree(NODE* N) {

	// 재귀
	if (N->rightSibling != NULL) 
		destroyTree(N->rightSibling);

	if (N->leftChild != NULL) 
		destroyTree(N->leftChild);

	// 링크 제거
	N->leftChild = NULL;
	N->rightSibling = NULL;

	// 메모리 해제
	printf("deleted node including data %d\n", N->data);
	deleteNode(N);
}

// leftChild Node 생성 및 추가.
void insertChildNode(NODE* parentNode, int data) {
	NODE* childNode = (NODE*)malloc(sizeof(NODE));

	// childNode 생성 및 초기화
	childNode->data = data;
	childNode->leftChild = NULL;
	childNode->rightSibling = NULL;

	// leftChild 포인터를 새로 만들어진 노드로 설정.
	parentNode->leftChild = childNode;
}

// rightSibling Node 생성 및 추가.
void insertSiblingNode(NODE* ptingNode,int data) {
	NODE* ptedNode = (NODE*)malloc(sizeof(NODE));

	// ptedNode 생성 및 초기화
	ptedNode->data = data;
	ptedNode->leftChild = NULL;
	ptedNode->rightSibling = NULL;

	// rightSibling 포인터를 새로 만들어진 노드로 설정.
	ptingNode->rightSibling = ptedNode;
}

// Node 제거
void deleteNode(NODE* N) {
	free(N);
}