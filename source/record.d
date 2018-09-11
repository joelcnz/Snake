import base;

struct Record {
    Frame[] _frames;

    void add(Frame frame) {
        _frames ~= frame;
        _frames[$ - 1].setup; //Frame(frame);
    }
}

struct Frame {
    Pointi[][] _mat;

    void setup() {
        with(g_global) {
            _mat.length = height;
            foreach(i; height)
                _mat[i].length = width;
        }
    }


}