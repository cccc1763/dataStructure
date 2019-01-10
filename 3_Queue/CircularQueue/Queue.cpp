#include "Queue.h"

void CQ_CreateQueue(CQueue** Queue, int cap) {
	(*Queue) = (CQueue*)malloc(sizeof(CQueue));
	(*Queue)->NodeArr = (NODE*)malloc(sizeof(NODE)*cap);

	(*Queue)->cap = cap;
	(*Queue)->front = 0;
	(*Queue)->rear = 0;
}

void CQ_DestroyQueue(CQueue* Queue) {
	free(Queue->NodeArr);
	free(Queue);
}

void CQ_Enqueue(CQueue* Queue, int value) {
	int pos = 0;
	// rear가 배열의 끝을 넘어갈 경우.
	if (Queue->rear == Queue->cap + 1) {
		Queue->rear = 0;
		pos = 0;
	}
	else
		pos = Queue->rear++;

	Queue->NodeArr[pos].value = value;
}

int CQ_Dequeue(CQueue* Queue) {
	int pos = Queue->front;

	// front가 배열의 끝에 도달.
	if (Queue->front == Queue->cap)
		Queue->front = 0;
	else
		++Queue->front;

	return Queue->NodeArr[pos].value;
}

int CQ_isEmpty(CQueue* Queue) {
	return (Queue->front == Queue->rear);
}

int CQ_isFull(CQueue* Queue) {
	if (Queue->front < Queue->rear)
		return (Queue->rear - Queue->front) == Queue->cap;
	else
		return (Queue->rear + 1) == Queue->front;
}