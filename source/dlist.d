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


    struct DListIterator
    {
        T front;
        T back;


        bool empty()
        {
            return ( front is null );
        }

        void popFront()
        {
            if ( front !is null )
            {
                // 1 element
                if ( front is back )
                {
                    front = null;
                    back = null;
                }
                else // front !is back
                {
                    front = front.next;
                }
            }
        }


        void popBack()
        {
            if ( back !is null )
            {
                // 1 element
                if ( front is back ) 
                {
                    front = null;
                    back  = null;
                }
                else // front !is back
                {
                    back = back.prev;
                }
            }
        }


        typeof( this ) save()
        {
            return typeof( this )( front, back );
        }


        size_t length()
        {
            if ( front is null )
            {
                return 0;
            }
            else
            {        
                size_t l;

                for ( auto cur = front, end = back.next; cur !is end; cur = cur.next )
                {
                    l += 1;
                }

                return l;
            }
        }
    }


    DListIterator iterator()
    {
        return DListIterator( front, back );
    }


    DListIterator iterator( T a, T b )
    {
        return DListIterator( a, b );
    }


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
            // 1 element
            if ( front is back )
            {
                front = null;
                back = null;
            }
            else // front !is back
            {
                front = front.next;
                //front.prev = null;
            }
        }
    }


    T opIndex( size_t i )
    {
        if ( front is null )
        {
            return null;
        }
        else // front !is null
        {
            size_t counter = i;

            for ( auto cur = front, end = back.next; cur !is end; cur = cur.next )
            {
                if ( counter == 0 )
                {
                    return cur;
                }

                counter -= 1;
            }

            return null;
        }
    }


    pragma( inline )
    void popBack()
    {
        if ( back !is null )
        {
            // 1 element
            if ( front is back ) 
            {
                front = null;
                back  = null;
            }
            else // front !is back
            {
                back = back.prev;
                //back.next = null;
            }
        }
    }


    pragma( inline )
    void insertFront( T op )
    {
        if ( front is null )
        {
            front   = op;
            back    = op;
            op.prev = null;
            op.next = null;
        }
        else // front !is null
        {
            op.prev    = null;
            op.next    = front;
            front.prev = op;
            front      = op;
        }
    }


    pragma( inline )
    void insertBack( T op )
    {
        if ( back is null )
        {
            front   = op;
            back    = op;
            op.prev = null;
            op.next = null;
        }
        else // back !is null
        {
            op.prev    = back;
            op.next    = null;
            back.next = op;
            back      = op;
        }
    }


    pragma( inline )
    void insertBefore( T op, T cur )
    {
        if ( cur == front )
        {
            op.next  = cur;
            op.prev  = null;
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
        op.next  = cur.next;
        cur.next = op;
        op.prev  = cur;

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

        if ( front is op )
            front = next;

        if ( back is op )
            back = prev;
    }


    pragma( inline )
    void opOpAssign( string op : "~" )( T b )
    {
        insertBack( b );
    }


    pragma( inline )
    bool opCast( T : bool )()
    {
        return !empty;
    }


    size_t length()
    {
        if ( front is null )
        {
            return 0;
        }
        else
        {        
            size_t l;

            for ( auto cur = front, end = back.next; cur !is end; cur = cur.next )
            {
                l += 1;
            }

            return l;
        }
    }


    void dump()
    {
        if ( front is null )
        {
            writeln( "dlist: null" );
        }
        else
        {
            writeln( "dlist:" );

            for ( auto cur = front, end = back.next; cur !is end; cur = cur.next )
            {
                writeln( "  ", cur );
            }
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
    assert( operations.front      == op );
    assert( operations.front.next == op2 );
    assert( operations.back.prev  == op3 );
    assert( operations.back       == op4 );
    assert( operations.back.prev  == op3 );
    assert( operations.length == 4 );
 
    import std.algorithm.searching : count;
    import std.algorithm.searching : find;
    assert( operations.iterator.empty == false );
    assert( operations.iterator.front !is null );
    assert( operations.iterator.back !is null );

    operations.iterator.popBack();
    assert( operations.iterator.empty == false );
    assert( operations.iterator.front !is null );
    assert( operations.iterator.back !is null );
    assert( operations.iterator.find( op4 ).empty == false );
    assert( operations.iterator.find( op4 ).front == op4 );

    operations.popBack();
    assert( operations.length == 3 );

    operations.popBack();
    assert( operations.length == 2 );

    operations.popBack();
    assert( operations.length == 1 );
    assert( operations.front == operations.back );
    assert( operations.front is operations.back );

    operations.popBack();
    assert( operations.front is null );
    assert( operations.back is null );
    assert( operations.length == 0 );
}


unittest
{
    class DrawOperation
    {
        wchar theChar;

        typeof( this ) prev;
        typeof( this ) next;

        this( wchar c )
        {
            theChar = c;
        }
    }

    DList!DrawOperation operations;

    operations.insertFront( new DrawOperation( 'A' ) );
    operations.insertFront( new DrawOperation( 'b' ) );
    operations.insertFront( new DrawOperation( 'c' ) );

    assert( operations.length == 3 );
    assert( operations.front.theChar           == 'c' );
    assert( operations.front.next.theChar      == 'b' );
    assert( operations.front.next.next.theChar == 'A' );
    assert( operations.back.theChar            == 'A' );
    assert( operations.back.prev.theChar       == 'b' );
    assert( operations.back.prev.prev.theChar  == 'c' );


    operations.remove( operations[ 2 ] );
    assert( operations.length == 2 );
}
