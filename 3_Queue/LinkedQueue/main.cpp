#include "LinkedQueue.h"

int main() {
	LQueue* Queue;
	NODE* a = new NODE;
	NODE* b = new NODE;
	NODE* c = new NODE;
	a->value = 5;
	b->value = 6;
	c->value = 7;

	LQ_CreateQueue(&Queue);

	LQ_Enqueue(Queue, a);
	LQ_Enqueue(Queue, b);
	LQ_Enqueue(Queue, c);

	LQ_Dequeue(Queue);
	LQ_Dequeue(Queue);
	LQ_Dequeue(Queue);

	return 0;
}