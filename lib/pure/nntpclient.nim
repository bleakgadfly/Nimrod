import sockets

type
    TNNTP* = object
        socket: TSocket
        user, pass: string
        address: string
        port: TPort
        setGroup: proc(article: string): TNNTPGroup

    PNNTP* = ref TNNTP

    TNNTPArticle* = object
        messageId: string
        head: string
        body: string
        stat: string

    TNNTPGroup* = object
        numberOfArticlesInGroup: int
        firstArticle: TNNTPArticle
        lastArticle: TNNTPArticle
        currentPointer: TNNTPArticlePointer
        sendCommand: proc(article: string): TNNTPArticle
        name: string

    TNNTPArticlePointer* = object
        articleNumber: int
        messageId: string

    TNNTPGroupSeq* = seq[TNNTPGroup]
    TNNTPArticleSeq* = seq[TNNTPArticle]

proc nntpClient(socket: TSocket, user, pass, address: string, port: TPort): PNNTP =
    new(result)

proc authenticate(client: TNNTP) =    
    var socket = client.socket
    socket.send("AUTHINFO USER " & client.user & "\c\L")
    socket.send("AUTHINFO PASS " & client.pass & "\c\L")

proc connect(client: TNNTP) =
    client.socket.connect(client.address, client.port);

proc disconnect(client: TNNTP): string =
    result = "";

proc article(group: TNNTPGroup, article: string): TNNTPArticle =
    var nntpArticle = group.sendCommand(article);
    #socket.send("ARTICLE " & article)
    result.messageId = ""
    result.head = ""
    result.body = ""
    result.stat = ""

proc head(group: TNNTPGroup, article: string): string =
    result = ""

proc body(group: TNNTPGroup, article: string): string =
    result = ""

proc stat(group: TNNTPGroup, messageId: string): TNNTPArticlePointer =
    result.messageId = ""
    result.articleNumber = 0

proc group(client: TNNTP, article: string): TNNTPGroup =
    var firstArticle = TNNTPArticle(messageId: "")
    var lastArticle = TNNTPArticle(messageId: "")

    result.numberOfArticlesInGroup = 0
    result.firstArticle = firstArticle
    result.lastArticle = lastArticle
    result.name = ""

proc last(group: TNNTPGroup, article: string): TNNTPArticle =
    result.messageId = ""
    result.head = ""
    result.body = ""
    result.stat = ""

proc next(group: TNNTPGroup, article: string): TNNTPArticle =
    result.messageId = ""
    result.head = ""
    result.body = ""
    result.stat = ""

#proc getList(client: TNNTPClient, article: string): TNNTPGroupSeq =
#    result = ""

#proc getNewGroups(client: TNNTPClient, article: string): TNNTPGroupSeq =
#    result = ""

proc newnews(group: TNNTPGroup, article: string): string =
    result = ""

proc help(client: TNNTP, article: string): string =
    result = ""

proc quit(client: TNNTP, article: string): string =
    result = ""

proc post(group: TNNTPGroup, article: string): string =
    result = ""

proc ihave(group: TNNTPGroup, article: string): string =
    result = ""

proc slave(client: TNNTP, article: string): string =
    result = ""


var csock: TSocket = socket()
csock.connect("freenews.netfront.net", TPort(119), AF_INET)
csock.send("LIST\c\L")

while True:
    var data: TaintedString = ""
    csock.readLine(data)
    echo(data)