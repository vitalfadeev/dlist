import std.traits;
import std.stdio : writeln;

/**
T should have "next", "prev" properties:
struct Node
{
    Node next;
    Node prev;
}
*/
struct DList( T )
  if ( hasMember!( T, "next" ) && hasMember!( T, "prev" ) )
{
    T front;
    T back;


    pragma( inline )
    bool empty()
    {
        return ( front is null );
    }


    pragma( inline )
    void popFront()
    {
        if ( front !is null )
        {
            auto next = front.next;
            front = next;

            if ( next is null )
                back = next;
        }
    }


    typeof( this ) save()
    {
        typeof( this ) saved;
        saved.front = front;
        saved.back  = back;

        return saved;
    }


    T opIndex( size_t i )
    {
        if ( front !is null )
        {
            size_t counter = i;

            for ( auto op = front; op !is null; op = op.next )
            {
                if ( counter == 0 )
                {
                    return op;
                }

                counter -= 1;
            }
        }

        return null;
    }


    pragma( inline )
    void popBack()
    {
        if ( back !is null )
        {
            auto prev = back.prev;
            back = prev;

            if ( prev is null )
                front = prev;
        }
    }


    pragma( inline )
    void insertFront( T op )
    {
        if ( front is null )
        {
            front = op;
            back  = op;
        }
        else // front !is null
        {
            op.prev    = null;
            op.next    = front;
            front.prev = op;
            front      = op;

            if ( back is null )
                back = op;
        }
    }


    pragma( inline )
    void insertBack( T op )
    {
        if ( back is null )
        {
            front = op;
            back  = op;
        }
        else // back !is null
        {
            op.prev    = back;
            op.next    = null;
            back.next = op;
            back      = op;

            if ( front is null )
                front = op;
        }
    }


    pragma( inline )
    void insertBefore( T op, T cur )
    {
        if ( cur == front )
        {
            op.next  = cur;
            cur.prev = op;
            front    = op;
        }
        else // cur != front
        {
            auto prev = cur.prev;
            prev.next = op;
            op.prev = prev;
            op.next  = cur;
            cur.prev = op;
        }
    }


    pragma( inline )
    void insertAfter( T op, T cur )
    {
        op.next = cur.next;
        cur.next = op;
        op.prev = cur;

        if ( back == cur )
            back = op;
    }


    pragma( inline )
    void remove( T op )
    {
        // Remove Draw Operation
        auto prev = op.prev;
        auto next = op.next;

        if ( prev !is null )
            prev.next = next;

        if ( next !is null )
            next.prev = prev;

        op.prev = null;
        op.next = null;

        if ( front == op )
            front = next;

        if ( back == op )
            back = prev;
    }


    pragma( inline )
    void opOpAssign( string op : "~" )( T b )
    {
        if ( empty )
        {
            front = b;
            back  = b;
        }
        else // front !is null
        {
            b.prev    = back;
            back.next = b;
            back      = b;
        }
    }


    pragma( inline )
    bool opCast( T : bool )()
    {
        return !empty;
    }


    void dump()
    {
        writeln( "dlist:" );

        for ( auto cur = front; cur !is null; cur = cur.next )
        {
            writeln( "  ", cur );
        }
    }
}


unittest
{
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
}
