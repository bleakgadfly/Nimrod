import sockets

type
    TNNTP* = object
        socket: TSocket
        user, pass: string
        address: string
        port: TPort
        sendCommand: proc(client: TNNTP, groupName: string): TNNTPGroup

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
        sendCommand: proc(messageId: string): string
        name: string

    TNNTPArticlePointer* = object
        articleNumber: int
        messageId: string

    TNNTPGroupSeq* = seq[TNNTPGroup]
    TNNTPArticleSeq* = seq[TNNTPArticle]

#template sendCommand(command: string): stmt =
#    var socket = client.socket
#    socket.send(command & "\c\L")

proc group(client: TNNTP, groupName: string): TNNTPGroup =
    var socket = client.socket
    socket.send("GROUP " & groupName)
    var firstArticle = TNNTPArticle(messageId: "")
    var lastArticle = TNNTPArticle(messageId: "")

    result.numberOfArticlesInGroup = 0
    result.firstArticle = firstArticle
    result.lastArticle = lastArticle
    result.name = ""
    return

proc nntpClient*(socket: TSocket, user, pass, address: string, port: TPort): PNNTP =
    new(result)
    result.group = group

proc authenticate*(client: TNNTP) =
    client.authenticate(client.user, client.pass)

proc authenticate*(client TNNTP, user, pass: string) =
    var socket = client.socket
    socket.send("AUTHINFO USER " & user & "\c\L")
    socket.send("AUTHINFO PASS " & pass & "\c\L")

proc connect*(client: TNNTP) =
    client.socket.connect(client.address, client.port);

proc connect*(client, TNNTP, address: string, port: TPort) =
    client.socket.connect(address, port)

proc article*(group: TNNTPGroup, articleId: string): TNNTPArticle =
    var nntpArticle = group.sendCommand("ARTICLE " & articleId);
    result.messageId = ""
    result.head = ""
    result.body = ""
    result.stat = ""

proc head*(group: TNNTPGroup, articleId: string): string =    
    var head = group.sendCommand("HEAD " & articleId)
    result = ""

proc body*(group: TNNTPGroup, articleId: string): string =
    var body = group.sendCommand("BODY " & articleId)
    result = ""

proc stat*(group: TNNTPGroup, articleId: string): TNNTPArticlePointer =
    discard group.sendCommand("STAT " & articleId)
    result.messageId = ""
    result.articleNumber = 0

proc last*(group: TNNTPGroup, article: string): TNNTPArticle =
    result.messageId = ""
    result.head = ""
    result.body = ""
    result.stat = ""

proc next*(group: TNNTPGroup, article: string): TNNTPArticle =
    result.messageId = ""
    result.head = ""
    result.body = ""
    result.stat = ""

#proc getList*(client: TNNTPClient, article: string): TNNTPGroupSeq =
#    result = ""

#proc getNewGroups*(client: TNNTPClient, article: string): TNNTPGroupSeq =
#    result = ""

proc newnews*(group: TNNTPGroup, article: string): string =
    result = ""

proc help*(client: TNNTP, article: string): string =
    result = ""

proc quit*(client: TNNTP, article: string): string =
    result = ""

proc post*(group: TNNTPGroup, article: string): string =
    result = ""

proc ihave*(group: TNNTPGroup, article: string): string =
    result = ""

proc slave*(client: TNNTP, article: string): string =
    result = ""


var csock: TSocket = socket()
csock.connect("freenews.netfront.net", TPort(119), AF_INET)
csock.send("LIST\c\L")

while True:
    var data: TaintedString = ""
    csock.readLine(data)
    echo(data)