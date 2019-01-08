#include "LinkedQueue.h"

void LQ_CreateQueue(LQueue** Queue) {
	(*Queue) = (LQueue*)malloc(sizeof(LQueue));
	(*Queue)->front = NULL;
	(*Queue)->rear = NULL;
	(*Queue)->cnt = 0;
}

void LQ_DestroyQueue(LQueue* Queue) {
	while (Queue->cnt != 0)
		LQ_Dequeue(Queue);
	free(Queue);
}

void LQ_Enqueue(LQueue* Queue, NODE* n) {
	if (Queue->front == NULL) {
		Queue->front = n;
		Queue->rear = n;
		Queue->cnt++;
	}
	else {
		Queue->rear->next = n;
		Queue->rear = n;
		Queue->cnt++;
	}
}

void LQ_Dequeue(LQueue* Queue) {
	NODE* deleteNode = Queue->front;
	if (Queue->front->next == NULL) {
		Queue->front = NULL;
		Queue->rear = NULL;
	}
	else
		Queue->front = Queue->front->next;
	Queue->cnt--;
	cout << deleteNode->value << " Dequeued" << endl;
	free(deleteNode);
}