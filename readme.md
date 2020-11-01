```
Dlist( T )
  bool    empty()
  void    popFront()
  DList!T save()
  T       opIndex( size_t i )
  void    popBack()
  void    insertFront( T op )
  void    insertBack( T op )
  void    insertBefore( T op, T cur )
  void    insertAfter( T op, T cur )
  void    remove( T op )
  void    opOpAssign( string op : "~" )( T b )
  bool    opCast( T : bool )()
  void    dump()

```

```
    class DocOperation
    {
        typeof( this ) prev;
        typeof( this ) next;
    }

    DList!DocOperation operations;

    auto op = new DocOperation();
    operations ~= op;
    assert( operations.front == op );
    assert( operations.back == op );   

    auto op2 = new DocOperation();
    operations ~= op2;
    assert( operations.front == op );
    assert( operations.back == op2 );   

    auto op3 = new DocOperation();
    operations ~= op3;
    assert( operations.front == op );
    assert( operations.back == op3 );   

    auto op4 = new DocOperation();
    operations ~= op4;
    operations.remove( op4 );
    assert( operations.front == op );
    assert( operations.back == op3 );   

    operations ~= op4;
    operations.popBack();
    assert( operations.front == op );
    assert( operations.back == op3 );   

    auto op0 = new DocOperation();
    operations.insertFront( op0 );
    assert( operations.front == op0 );
    assert( operations.back == op3 );   

    operations.popFront();
    assert( operations.front == op );
    assert( operations.back == op3 );   

    operations.insertBack( op4 );
    assert( operations.front == op );
    assert( operations.back == op4 );   

    import std.algorithm.searching : count;
    assert( operations.count == 4 );
```
