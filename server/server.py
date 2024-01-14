# app.py

from flask import Flask

app = Flask(__name__)

@app.route('/')
def index():
    # Call Julia function from Python using PyJulia
    from julia.api import Julia
    jl = Julia(compiled_modules=False)
    
    # Include Julia script
    jl.include("../logic/GameUtilitaries.jl")

    # Call Julia function
    result = jl.eval("Test()")

    print(result)
    return result

if __name__ == '__main__':
    app.run(debug=True)
