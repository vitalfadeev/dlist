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

    struct DocFlow
    {
        DList!DocOperation operations;
    }

    DocFlow docFlow;
    auto op = new DocOperation();
    docFlow.operations ~= op;
    assert( docFlow.operations.front == op );
    assert( docFlow.operations.back == op );   

```
