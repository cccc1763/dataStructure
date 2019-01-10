#include "tree.h"

// Ʈ�� ����.
void createTree(TREE** Tree, int topData) {
	(*Tree) = (TREE*)malloc(sizeof(TREE));
	(*Tree)->topNode = (NODE*)malloc(sizeof(NODE));
	(*Tree)->topNode->data = topData;
	(*Tree)->topNode->leftChild = NULL;
	(*Tree)->topNode->rightSibling = NULL;
}

// Ʈ�� ����. ����Լ� ���
void destroyTree(NODE* N) {

	// ���
	if (N->rightSibling != NULL) 
		destroyTree(N->rightSibling);

	if (N->leftChild != NULL) 
		destroyTree(N->leftChild);

	// ��ũ ����
	N->leftChild = NULL;
	N->rightSibling = NULL;

	// �޸� ����
	printf("deleted node including data %d\n", N->data);
	deleteNode(N);
}

// leftChild Node ���� �� �߰�.
void insertChildNode(NODE* parentNode, int data) {
	NODE* childNode = (NODE*)malloc(sizeof(NODE));

	// childNode ���� �� �ʱ�ȭ
	childNode->data = data;
	childNode->leftChild = NULL;
	childNode->rightSibling = NULL;

	// leftChild �����͸� ���� ������� ���� ����.
	parentNode->leftChild = childNode;
}

// rightSibling Node ���� �� �߰�.
void insertSiblingNode(NODE* ptingNode,int data) {
	NODE* ptedNode = (NODE*)malloc(sizeof(NODE));

	// ptedNode ���� �� �ʱ�ȭ
	ptedNode->data = data;
	ptedNode->leftChild = NULL;
	ptedNode->rightSibling = NULL;

	// rightSibling �����͸� ���� ������� ���� ����.
	ptingNode->rightSibling = ptedNode;
}

// Node ����
void deleteNode(NODE* N) {
	free(N);
}