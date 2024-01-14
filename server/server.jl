using HTTP
using Sockets

function handle_request(request::HTTP.Request)
    return HTTP.Response("Hello, World from Julia Server!", 200)
end

function handle_connection(sock::Sockets.TCPSocket)
    try
        req = HTTP.parse_request(sock)
        res = handle_request(req)
        HTTP.write_response(sock, res)
    catch err
        @error "Error processing request: $err"
    finally
        close(sock)
    end
end

function start_server()
    server = HTTP.listen("127.0.0.1", 8000)
    @info "Server listening on http://127.0.0.1:8000/"

    while true
        sock = accept(server)
        Threads.@spawn(handle_connection, sock)
    end
end

start_server()