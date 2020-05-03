#ifndef SINGLETON_H
#define SINGLETON_H

/** from https://gist.github.com/sagi-z/c30f7f4aab63f0016a32040b023a86a9#file-singleton-h
 * https://www.theimpossiblecode.com/blog/c11-generic-singleton-pattern/
 */

template <typename T, typename CONTEXT>
class Singleton
{
public:
    // Very fast inlined operator accessors
    T* operator->() {return mpInstance;}
    const T* operator->() const {return mpInstance;}
    T& operator*() {return *mpInstance;}
    const T& operator*() const {return *mpInstance;}

    // TODO: delete this method - it was
    //       just used for benchmarking in
    //       the post.
    static T *getInstance()
    {
        static bool static_init = []()->bool {
            mpInstance = new T;
            return true;
        }();
        return mpInstance;
    }

protected:
    Singleton()
    {
        static bool static_init = []()->bool {
            mpInstance = new T;
            return true;
        }();
    }

    Singleton(int)
    {
        static bool static_init = []()->bool {
            mpInstance = CONTEXT::init();
            return true;
        }();
    }

private:
    static T *mpInstance;
};

template <typename T, typename CONTEXT>
T *Singleton<T, CONTEXT>::mpInstance;

#endif // SINGLETON_H
