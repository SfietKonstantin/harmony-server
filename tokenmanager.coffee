root = exports ? this

class TokenManager
    tokens: []
    websockets: {}
    secret: null

    generateToken: (authCode, jwt) =>
        token = jwt.sign({'auth_code': authCode}, @secret, { expiresInMinutes: 60 * 24 })
        if token in @tokens
            return null
        @tokens.push token
        return token

    removeToken: (token) =>
        index = @tokens.indexOf token
        @tokens.splice index

    websocketAddable: (token) =>
        return ((token in @tokens) and (token not of @websockets))

    addWebSocket: (token, webSocket) =>
        if @websocketAddable(token)
            @websockets[token] = webSocket

            # Remove it when needed
            webSocket.on 'close', =>
                delete @websockets[token]
                @removeToken token

root.tm = new TokenManager()