#include "tree.h"

int main() {

	TREE* Tree;
	createTree(&Tree, 10);
	insertChildNode(Tree->topNode, 20);
	insertSiblingNode(Tree->topNode->leftChild, 40);
	insertSiblingNode(Tree->topNode->leftChild->rightSibling, 50);
	insertChildNode(Tree->topNode->leftChild->rightSibling->rightSibling, 60);
	insertChildNode(Tree->topNode->leftChild->rightSibling->rightSibling->leftChild, 60);
	insertChildNode(Tree->topNode->leftChild,30);

	destroyTree(Tree->topNode);
	return 0;
}