//
//  RedditCommentsViewController.swift
//  Commenting
//
//
//
//

import UIKit
import SwiftyComments
import SkeletonView
import SnapKit
class FoldableRedditCommentsViewController: RedditCommentsViewController, CommentsViewDelegate {
    
    
    func commentCellExpanded(atIndex index: Int) {
        updateCellFoldState(false, atIndex: index)
    }
    
    func commentCellFolded(atIndex index: Int) {
        updateCellFoldState(true, atIndex: index)
    }
    
    private func updateCellFoldState(_ folded: Bool, atIndex index: Int) {
        let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as! RedditCommentCell
        cell.animateIsFolded(fold: folded)
        (self.currentlyDisplayed[index] as! RichComment).isFolded = folded
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
    
    override func viewDidLoad() {
        self.fullyExpanded = true
        super.viewDidLoad()
        self.delegate = self
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCom: AbstractComment = currentlyDisplayed[indexPath.row]
        let selectedIndex = indexPath.row
        
        // Enable cell folding for comments without replies
        if selectedCom.replies.count == 0 {
            if (selectedCom as! RichComment).isFolded {
                commentCellExpanded(atIndex: selectedIndex)
            } else {
                commentCellFolded(atIndex: selectedIndex)
            }
        } else {
            super.tableView(tableView, didSelectRowAt: indexPath)
        }
    }
    
    
}
class RedditCommentsViewController: CommentsViewController {
    //TODO:发表评论的view（弃用，评论视图放到父视图）
    lazy var postCommentView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: UIDevice.current.isX() ? finalScreenH - finalStatusBarH - IphonexHomeIndicatorH - postCommentViewH - finalScreenW / 16 * 9 - 50 : finalScreenH - postCommentViewH  - finalScreenW / 16 * 9 - 50, width: finalScreenW, height: postCommentViewH))
        view.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        return view
    }()
    ///加载遮盖view
    lazy var alphaView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: finalScreenW, height: finalScreenH - finalStatusBarH - finalNavigationBarH - finalScreenW / 16 * 9 - 50))
        view.backgroundColor = .white
        let loadingView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        loadingView.startAnimating()
        loadingView.center = view.center
        view.addSubview(loadingView)
        return view
    }()
    let postCommentViewH:CGFloat = 50
    private let commentCellId = "redditComentCellId"
    var allComments: [RichComment] = [] // All the comments (nested, not in a linear format)
    ///评论数据
    var commentsData: [CommentModel] = []{
        didSet{
            allComments = []
            for comment in commentsData {
                let com = AttributedTextComment()
                com.headIco = comment.userLogo
                com.id = Int(comment.id)
                com.body = comment.content
                com.posterName = comment.nickName
                com.postedDate = Double(arc4random_uniform(UInt32(1483228800 - 1262304000)-1)) + 1262304000
                com.upvotes = Int(arc4random_uniform(500)) + 1
                com.downvotes = Int(arc4random_uniform(100)) + 1
                com.title = Lorem.sentence
                allComments.append(com)
                currentlyDisplayed = allComments
            }
//            print(commentsData.count)
            self.tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.view.addSubview(alphaView)
        requestData()
        tableView.register(RedditCommentCell.self, forCellReuseIdentifier: commentCellId)
        
        tableView.backgroundColor = RedditConstants.backgroundColor
        tableView.isSkeletonable = true
        
        allComments = RandomDiscussion.generate().comments
        
        currentlyDisplayed = allComments
        
        self.swipeToHide = true
        self.swipeActionAppearance.swipeActionColor = RedditConstants.flashyColor
        
//        self.view.addSubview(postCommentView)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        super.scrollViewDidScroll(scrollView)
        if scrollView.isMember(of: UITableView.self){
            let offsetY = scrollView.contentOffset.y
            postCommentView.frame.origin.y = offsetY + (UIDevice.current.isX() ? finalScreenH - finalStatusBarH - IphonexHomeIndicatorH - postCommentViewH - finalScreenW / 16 * 9 - 50 : finalScreenH - postCommentViewH  - finalScreenW / 16 * 9 - 50)
        }
    }
    
    ///请求评论数据
    func requestData(){
        AppConfigViewModel.requestComments(url: API_Comments) { (comments) in
            self.commentsData = comments
        }
    }
    
    override open func commentsView(_ tableView: UITableView, commentCellForModel commentModel: AbstractComment, atIndexPath indexPath: IndexPath) -> CommentCell {
        let commentCell = tableView.dequeueReusableCell(withIdentifier: commentCellId, for: indexPath) as! RedditCommentCell
        
        let comment = currentlyDisplayed[indexPath.row] as! RichComment
        if self.commentsData.count > 0 {
            commentCell.headIconStr = self.commentsData[indexPath.row].userLogo
            commentCell.commentContent = self.commentsData[indexPath.row].content
            commentCell.posterName = self.commentsData[indexPath.row].nickName
            commentCell.date = self.commentsData[indexPath.row].createDate
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                commentCell.content.hideMySkeleton()
            }
            
        }else{
//            comment.body
            commentCell.headIconStr = " "
            commentCell.level = comment.level
            commentCell.commentContent = " "
            commentCell.posterName = " "
            commentCell.date = " "
            commentCell.upvotes = comment.upvotes
            commentCell.isFolded = comment.isFolded && !isCellExpanded(indexPath: indexPath)
            commentCell.content.showMySkeleton()
        }
        
//        commentCell.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        return commentCell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.navigationController?.navigationBar.barTintColor = RedditConstants.flashyColor
//        self.navigationController?.navigationBar.tintColor = .white
//        UIApplication.shared.statusBarStyle = .lightContent
    }
}

class RandomDiscussion {
    var comments: [AttributedTextComment]! = []
    
    
    /**
     Generate a random list of comments
     - note: the postedDate of the replies may be anterior to the comment they are a reply to, and you know what? No one cares.
     - parameters:
     - size: number of root comments
     - maximumChildren: maximum number of replies to a comment. This number is randomly chosen.
     */
    static func generate(size: Int = 10, maximumChildren: Int = 0) -> RandomDiscussion {
        let discussion = RandomDiscussion()
        for _ in 0 ..< size {
            var rootComment = randomComent()
            addReplyRecurs(&rootComment, maximumChildren: maximumChildren)
            discussion.comments.append(rootComment)
        }
        return discussion
    }
    
    /**
     Generate a random, lipsum-filled, comment.
     */
    static func randomComent() -> AttributedTextComment {
        let com = AttributedTextComment()
        com.headIco = "http://thirdwx.qlogo.cn/mmopen/vi_32/Q0j4TwGTfTJcrsd2TcCfqE78SwqUQiaYJpju1X2vgMVrkMxkz2rblcwcUWPbKmRdqGroo2LfcQhplj6C7C9pXQg/132"
        com.id = Int(arc4random_uniform(100000)) + 1
        com.body = Lorem.sentences(Int(arc4random_uniform(4)) + 1)
        com.posterName = Lorem.word
        com.postedDate = Double(arc4random_uniform(UInt32(1483228800 - 1262304000)-1)) + 1262304000
        com.upvotes = Int(arc4random_uniform(500)) + 1
        com.downvotes = Int(arc4random_uniform(100)) + 1
        com.title = Lorem.sentence
        return com
    }
    
    /**
     Recursively add a random number of replies to parent.
     At each recursion, the maximum number of children is
     decreased by 1 until it reaches 0.
     */
    private static func addReplyRecurs( _ parent: inout AttributedTextComment, maximumChildren: Int) {
        if maximumChildren == 0 { return }
        for _ in 0..<(Int(arc4random_uniform(UInt32(maximumChildren-1))) + 1) {
            var com = randomComent()
            parent.addReply(com)
            com.replyTo = parent
            com.level = parent.level+1
            addReplyRecurs(&com, maximumChildren: maximumChildren-1)
        }
        
    }
    
    
}

/// Model of a comment with attributedText content.
class AttributedTextComment: RichComment {
    var attributedContent: NSAttributedString?
}


/**
 This class models a comment with all the most
 common attributes in the commenting systems.
 It's used as an exemple through the implemented
 commenting systems.
 **/
class RichComment: BaseComment {
    var headIco:String?
    var id: Int?
    var upvotes: Int?
    var downvotes: Int?
    var body: String?
    var title: String?
    var posterName: String?
    var postedDate: Double? // epochtime (since 1970)
    var upvoted: Bool = false
    var downvoted: Bool = false
    var isFolded: Bool = false
    
    /**
     Express the postedDate in following format: "[x] [time period] ago"
     */
    func soMuchTimeAgo() -> String? {
        if self.postedDate == nil {
            return nil
        }
        let diff = Date().timeIntervalSince1970 - self.postedDate!
        var str: String = ""
        if  diff < 60 {
            str = "now"
        } else if diff < 3600 {
            let out = Int(round(diff/60))
            str = (out == 1 ? "1 minute ago" : "\(out) 分钟 之前")
        } else if diff < 3600 * 24 {
            let out = Int(round(diff/3600))
            str = (out == 1 ? "1 hour ago" : "\(out) 小时 之前")
        } else if diff < 3600 * 24 * 2 {
            str = "yesterday"
        } else if diff < 3600 * 24 * 7 {
            let out = Int(round(diff/(3600*24)))
            str = (out == 1 ? "1 day ago" : "\(out) 天 之前")
        } else if diff < 3600 * 24 * 7 * 4{
            let out = Int(round(diff/(3600*24*7)))
            str = (out == 1 ? "1 week ago" : "\(out) 星期 之前")
        } else if diff < 3600 * 24 * 7 * 4 * 12{
            let out = Int(round(diff/(3600*24*7*4)))
            str = (out == 1 ? "1 month ago" : "\(out) 月 之前")
        } else {//if diff < 3600 * 24 * 7 * 4 * 12{
            let out = Int(round(diff/(3600*24*7*4*12)))
            str = (out == 1 ? "1 year ago" : "\(out) 年 之前")
        }
        return str
    }
}

class BaseComment: AbstractComment {
    var replies: [AbstractComment]! = []
    var level: Int!
    weak var replyTo: AbstractComment?
    
    convenience init() {
        self.init(level: 0, replyTo: nil)
    }
    init(level: Int, replyTo: BaseComment?) {
        self.level = level
        self.replyTo = replyTo
    }
    func addReply(_ reply: BaseComment) {
        self.replies.append(reply)
    }
    
}


open class Lorem {
    
    // ======================================================= //
    // MARK: - Text
    // ======================================================= //
    
    public static var word: String {
        return allWords.randomElement + "66666"
    }
    
    public static func words(_ count: Int) -> String {
        return compose({ word }, count: count, middleSeparator: .Space)
    }
    
    public static var sentence: String {
        let numberOfWordsInSentence = Int.random(min: 4, max: 16)
        let capitalizeFirstLetterDecorator: (String) -> String = { $0.stringWithCapitalizedFirstLetter }
        return compose({ word }, count: numberOfWordsInSentence, middleSeparator: .Space, endSeparator: .Dot, decorator: capitalizeFirstLetterDecorator)
    }
    
    public static func sentences(_ count: Int) -> String {
        return compose({ sentence }, count: count, middleSeparator: .Space)
    }
    
    public static var paragraph: String {
        let numberOfSentencesInParagraph = Int.random(min: 3, max: 9)
        return sentences(numberOfSentencesInParagraph)
    }
    
    public static func paragraphs(_ count: Int) -> String {
        return compose({ paragraph }, count: count, middleSeparator: .NewLine)
    }
    
    public static var title: String {
        let numberOfWordsInTitle = Int.random(min: 2, max: 7)
        let capitalizeStringDecorator: (String) -> String = { $0.capitalized }
        return compose({ word }, count: numberOfWordsInTitle, middleSeparator: .Space, decorator: capitalizeStringDecorator)
    }
    
    // ======================================================= //
    // MARK: - Misc
    // ======================================================= //
    
    public static var firstName: String {
        return firstNames.randomElement
    }
    
    public static var lastName: String {
        return lastNames.randomElement
    }
    
    public static var name: String {
        return "\(firstName) \(lastName)"
    }
    
    public static var email: String {
        let delimiter = emailDelimiters.randomElement
        let domain = emailDomains.randomElement
        return "\(firstName)\(delimiter)\(lastName)@\(domain)".lowercased()
    }
    
    public static var URL: NSURL {
        return NSURL(string: "http://\(domains.randomElement)/")!
    }
    
    public static var tweet: String {
        return tweets.randomElement
    }
    
    public static var date: NSDate {
        let currentDate = NSDate()
        let currentCalendar = NSCalendar.current
        let referenceDateComponents = NSDateComponents()
        referenceDateComponents.year = -4
        let referenceDate = currentCalendar.date(byAdding: referenceDateComponents as DateComponents, to: currentDate as Date)
        let timeIntervalSinceReferenceDate = currentDate.timeIntervalSince(referenceDate!)
        let randomTimeInterval = TimeInterval(Int.random(max: Int(timeIntervalSinceReferenceDate)))
        return referenceDate!.addingTimeInterval(randomTimeInterval) as NSDate
    }
    
    // ======================================================= //
    // MARK: - Private
    // ======================================================= //
    
    fileprivate enum Separator: String {
        case None = ""
        case Space = " "
        case Dot = "."
        case NewLine = "\n"
    }
    
    fileprivate static func compose(_ provider: () -> String, count: Int, middleSeparator: Separator, endSeparator: Separator = .None, decorator: ((String) -> String)? = nil) -> String {
        var composedString = ""
        
        for index in 0..<count {
            composedString += provider()
            
            if (index < count - 1) {
                composedString += middleSeparator.rawValue
            } else {
                composedString += endSeparator.rawValue
            }
        }
        
        if let decorator = decorator {
            return decorator(composedString)
        } else {
            return composedString
        }
    }
    
    // ======================================================= //
    // MARK: - Data
    // ======================================================= //
    
    fileprivate static let allWords = "alias consequatur aut perferendis sit voluptatem accusantium doloremque aperiam eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo aspernatur aut odit aut fugit sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt neque dolorem ipsum quia dolor sit amet consectetur adipisci velit sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem ut enim ad minima veniam quis nostrum exercitationem ullam corporis nemo enim ipsam voluptatem quia voluptas sit suscipit laboriosam nisi ut aliquid ex ea commodi consequatur quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae et iusto odio dignissimos ducimus qui blanditiis praesentium laudantium totam rem voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident sed ut perspiciatis unde omnis iste natus error similique sunt in culpa qui officia deserunt mollitia animi id est laborum et dolorum fuga et harum quidem rerum facilis est et expedita distinctio nam libero tempore cum soluta nobis est eligendi optio cumque nihil impedit quo porro quisquam est qui minus id quod maxime placeat facere possimus omnis voluptas assumenda est omnis dolor repellendus temporibus autem quibusdam et aut consequatur vel illum qui dolorem eum fugiat quo voluptas nulla pariatur at vero eos et accusamus officiis debitis aut rerum necessitatibus saepe eveniet ut et voluptates repudiandae sint et molestiae non recusandae itaque earum rerum hic tenetur a sapiente delectus ut aut reiciendis voluptatibus maiores doloribus asperiores repellat".components(separatedBy: " ")
    
    fileprivate static let firstNames = "Judith Angelo Margarita Kerry Elaine Lorenzo Justice Doris Raul Liliana Kerry Elise Ciaran Johnny Moses Davion Penny Mohammed Harvey Sheryl Hudson Brendan Brooklynn Denis Sadie Trisha Jacquelyn Virgil Cindy Alexa Marianne Giselle Casey Alondra Angela Katherine Skyler Kyleigh Carly Abel Adrianna Luis Dominick Eoin Noel Ciara Roberto Skylar Brock Earl Dwayne Jackie Hamish Sienna Nolan Daren Jean Shirley Connor Geraldine Niall Kristi Monty Yvonne Tammie Zachariah Fatima Ruby Nadia Anahi Calum Peggy Alfredo Marybeth Bonnie Gordon Cara John Staci Samuel Carmen Rylee Yehudi Colm Beth Dulce Darius inley Javon Jason Perla Wayne Laila Kaleigh Maggie Don Quinn Collin Aniya Zoe Isabel Clint Leland Esmeralda Emma Madeline Byron Courtney Vanessa Terry Antoinette George Constance Preston Rolando Caleb Kenneth Lynette Carley Francesca Johnnie Jordyn Arturo Camila Skye Guy Ana Kaylin Nia Colton Bart Brendon Alvin Daryl Dirk Mya Pete Joann Uriel Alonzo Agnes Chris Alyson Paola Dora Elias Allen Jackie Eric Bonita Kelvin Emiliano Ashton Kyra Kailey Sonja Alberto Ty Summer Brayden Lori Kelly Tomas Joey Billie Katie Stephanie Danielle Alexis Jamal Kieran Lucinda Eliza Allyson Melinda Alma Piper Deana Harriet Bryce Eli Jadyn Rogelio Orlaith Janet Randal Toby Carla Lorie Caitlyn Annika Isabelle inn Ewan Maisie Michelle Grady Ida Reid Emely Tricia Beau Reese Vance Dalton Lexi Rafael Makenzie Mitzi Clinton Xena Angelina Kendrick Leslie Teddy Jerald Noelle Neil Marsha Gayle Omar Abigail Alexandra Phil Andre Billy Brenden Bianca Jared Gretchen Patrick Antonio Josephine Kyla Manuel Freya Kellie Tonia Jamie Sydney Andres Ruben Harrison Hector Clyde Wendell Kaden Ian Tracy Cathleen Shawn".components(separatedBy: " ")
    
    fileprivate static let lastNames = "Chung Chen Melton Hill Puckett Song Hamilton Bender Wagner McLaughlin McNamara Raynor Moon Woodard Desai Wallace Lawrence Griffin Dougherty Powers May Steele Teague Vick Gallagher Solomon Walsh Monroe Connolly Hawkins Middleton Goldstein Watts Johnston Weeks Wilkerson Barton Walton Hall Ross Chung Bender Woods Mangum Joseph Rosenthal Bowden Barton Underwood Jones Baker Merritt Cross Cooper Holmes Sharpe Morgan Hoyle Allen Rich Rich Grant Proctor Diaz Graham Watkins Hinton Marsh Hewitt Branch Walton O'Brien Case Watts Christensen Parks Hardin Lucas Eason Davidson Whitehead Rose Sparks Moore Pearson Rodgers Graves Scarborough Sutton Sinclair Bowman Olsen Love McLean Christian Lamb James Chandler Stout Cowan Golden Bowling Beasley Clapp Abrams Tilley Morse Boykin Sumner Cassidy Davidson Heath Blanchard McAllister McKenzie Byrne Schroeder Griffin Gross Perkins Robertson Palmer Brady Rowe Zhang Hodge Li Bowling Justice Glass Willis Hester Floyd Graves Fischer Norman Chan Hunt Byrd Lane Kaplan Heller May Jennings Hanna Locklear Holloway Jones Glover Vick O'Donnell Goldman McKenna Starr Stone McClure Watson Monroe Abbott Singer Hall Farrell Lucas Norman Atkins Monroe Robertson Sykes Reid Chandler Finch Hobbs Adkins Kinney Whitaker Alexander Conner Waters Becker Rollins Love Adkins Black Fox Hatcher Wu Lloyd Joyce Welch Matthews Chappell MacDonald Kane Butler Pickett Bowman Barton Kennedy Branch Thornton McNeill Weinstein Middleton Moss Lucas Rich Carlton Brady Schultz Nichols Harvey Stevenson Houston Dunn West O'Brien Barr Snyder Cain Heath Boswell Olsen Pittman Weiner Petersen Davis Coleman Terrell Norman Burch Weiner Parrott Henry Gray Chang McLean Eason Weeks Siegel Puckett Heath Hoyle Garrett Neal Baker Goldman Shaffer Choi Carver".components(separatedBy: " ")
    
    fileprivate static let emailDomains = "gmail.com yahoo.com hotmail.com email.com live.com me.com mac.com aol.com fastmail.com mail.com".components(separatedBy: " ")
    
    fileprivate static let emailDelimiters = ["", ".", "-", "_"]
    
    fileprivate static let domains = "twitter.com google.com youtube.com wordpress.org adobe.com blogspot.com godaddy.com wikipedia.org wordpress.com yahoo.com linkedin.com amazon.com flickr.com w3.org apple.com myspace.com tumblr.com digg.com microsoft.com vimeo.com pinterest.com qq.com stumbleupon.com youtu.be addthis.com miibeian.gov.cn delicious.com baidu.com feedburner.com bit.ly".components(separatedBy: " ")
    
    // Source: http://www.kevadamson.com/talking-of-design/article/140-alternative-characters-to-lorem-ipsum
    fileprivate static let tweets = ["Far away, in a forest next to a river beneath the mountains, there lived a small purple otter called Philip. Philip likes sausages. The End.", "He liked the quality sausages from Marks & Spencer but due to the recession he had been forced to shop in a less desirable supermarket. End.", "He awoke one day to find his pile of sausages missing. Roger the greedy boar with human eyes, had skateboarded into the forest & eaten them!"]
    
}

private extension Int {
    
    static func random(min: Int = 0, max: Int) -> Int {
        assert(min >= 0)
        assert(min < max)
        
        return Int(arc4random_uniform(UInt32((max - min) + 1))) + min
    }
    
}

private extension Array {
    
    var randomElement: Element {
        return self[Int.random(max: count - 1)]
    }
    
}

private extension String {
    
    var stringWithCapitalizedFirstLetter: String {
        let capitalizedFirstLetter = prefix(1).capitalized
        return replacingCharacters(in: ..<index(startIndex, offsetBy: 1), with: capitalizedFirstLetter)
    }
    
}


