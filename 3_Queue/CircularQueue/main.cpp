#include "Queue.h"

int main() {
	CQueue* Queue;
	CQ_CreateQueue(&Queue, 5);

	CQ_Enqueue(Queue, 30);
	CQ_Enqueue(Queue, 40);
	CQ_Enqueue(Queue, 50);
	CQ_Enqueue(Queue, 60);
	CQ_Enqueue(Queue, 70);


	cout << (CQ_isFull(Queue)?"full":"capable") << endl;

	cout << CQ_Dequeue(Queue) << endl;
	cout << CQ_Dequeue(Queue) << endl;
	cout << CQ_Dequeue(Queue) << endl;
	cout << CQ_Dequeue(Queue) << endl;
	cout << CQ_Dequeue(Queue) << endl;


	return 0;
}