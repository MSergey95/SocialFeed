import UIKit

class PostTableViewCell: UITableViewCell {

    // MARK: - UI Elements

    // Верхняя панель: аватарка + имя + кнопка «…»
    private let topContainer = UIView()
    private let avatarImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 18 // для круглой аватарки 36x36
        return iv
    }()
    private let usernameLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: 14)
        lbl.textColor = .black
        return lbl
    }()
    private let moreButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        btn.tintColor = .black
        return btn
    }()

    // Основная картинка поста
    private let postImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()

    // Нижняя панель: иконки лайк, коммент, share
    private let iconsContainer = UIView()
    private let likeButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "heart"), for: .normal)
        btn.tintColor = .black
        return btn
    }()
    private let commentButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "message"), for: .normal)
        btn.tintColor = .black
        return btn
    }()
    private let shareButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "paperplane"), for: .normal)
        btn.tintColor = .black
        return btn
    }()

    // Счётчик лайков
    private let likeCountLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: 14)
        lbl.textColor = .black
        return lbl
    }()

    // Текст поста
    private let postBodyLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 14)
        lbl.textColor = .black
        lbl.numberOfLines = 0
        return lbl
    }()

    // Коллбек для лайка (чтобы обновлять модель в контроллере)
    var onLikeTapped: ((Post) -> Void)?
    private var currentPost: Post?

    // MARK: - Инициализаторы

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }

    // MARK: - UI Setup

    private func setupUI() {
        // Убираем стандартный фон и selection
        selectionStyle = .none
        contentView.backgroundColor = .white //  фон

        // Добавляем subviews
        [topContainer, postImageView, iconsContainer, likeCountLabel, postBodyLabel].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        [avatarImageView, usernameLabel, moreButton].forEach {
            topContainer.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        [likeButton, commentButton, shareButton].forEach {
            iconsContainer.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        // Слушатели нажатия
        likeButton.addTarget(self, action: #selector(likeTapped), for: .touchUpInside)
        // Можно добавить commentButton, shareButton action при желании

        // Добавим жест двойного тапа на postImageView для лайка
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTapOnImage))
        doubleTap.numberOfTapsRequired = 2
        postImageView.isUserInteractionEnabled = true
        postImageView.addGestureRecognizer(doubleTap)

        // Layout constraints
        NSLayoutConstraint.activate([
            // topContainer (аватарка + имя + ...)
            topContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            topContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            topContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            topContainer.heightAnchor.constraint(equalToConstant: 44),

            // Аватарка
            avatarImageView.leadingAnchor.constraint(equalTo: topContainer.leadingAnchor),
            avatarImageView.centerYAnchor.constraint(equalTo: topContainer.centerYAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 36),
            avatarImageView.heightAnchor.constraint(equalToConstant: 36),

            // Имя пользователя
            usernameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 8),
            usernameLabel.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),

            // Кнопка "..."
            moreButton.trailingAnchor.constraint(equalTo: topContainer.trailingAnchor),
            moreButton.centerYAnchor.constraint(equalTo: topContainer.centerYAnchor),

            // Основная картинка поста
            postImageView.topAnchor.constraint(equalTo: topContainer.bottomAnchor, constant: 8),
            postImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            postImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            postImageView.heightAnchor.constraint(equalTo: postImageView.widthAnchor, multiplier: 1.0),
            // Сделаем квадратную

            // Иконки (лайк, коммент, share)
            iconsContainer.topAnchor.constraint(equalTo: postImageView.bottomAnchor, constant: 8),
            iconsContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            iconsContainer.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -12),
            iconsContainer.heightAnchor.constraint(equalToConstant: 30),

            likeButton.leadingAnchor.constraint(equalTo: iconsContainer.leadingAnchor),
            likeButton.centerYAnchor.constraint(equalTo: iconsContainer.centerYAnchor),
            likeButton.widthAnchor.constraint(equalToConstant: 28),
            likeButton.heightAnchor.constraint(equalToConstant: 28),

            commentButton.leadingAnchor.constraint(equalTo: likeButton.trailingAnchor, constant: 16),
            commentButton.centerYAnchor.constraint(equalTo: iconsContainer.centerYAnchor),
            commentButton.widthAnchor.constraint(equalToConstant: 28),
            commentButton.heightAnchor.constraint(equalToConstant: 28),

            shareButton.leadingAnchor.constraint(equalTo: commentButton.trailingAnchor, constant: 16),
            shareButton.centerYAnchor.constraint(equalTo: iconsContainer.centerYAnchor),
            shareButton.widthAnchor.constraint(equalToConstant: 28),
            shareButton.heightAnchor.constraint(equalToConstant: 28),

            // Счётчик лайков
            likeCountLabel.topAnchor.constraint(equalTo: iconsContainer.bottomAnchor, constant: 4),
            likeCountLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),

            // Текст поста
            postBodyLabel.topAnchor.constraint(equalTo: likeCountLabel.bottomAnchor, constant: 4),
            postBodyLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            postBodyLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            postBodyLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }

    // MARK: - Config

    func configure(with post: Post) {
        currentPost = post
        print("CONFIGURE: post.id=\(post.id), imageDataSize=\(post.imageData?.count ?? 0)")
        // Аватарка
        if let avatarData = post.avatarData {
            avatarImageView.image = UIImage(data: avatarData)
        } else {
            avatarImageView.image = UIImage(named: "avatar_placeholder")
        }

        usernameLabel.text = "user_\(post.userId)"

        // Основная картинка
        if let imageData = post.imageData {
            postImageView.image = UIImage(data: imageData)
        } else {
            postImageView.image = UIImage(named: "photo_placeholder")
        }

        // Лайк
        let heartName = post.isLiked ? "heart.fill" : "heart"
        likeButton.setImage(UIImage(systemName: heartName), for: .normal)
        likeButton.tintColor = post.isLiked ? .red : .black

        // Счётчик лайков (для примера, если isLiked – 1 like)
        likeCountLabel.text = post.isLiked ? "1 like" : "0 likes"

        // Текст поста
        postBodyLabel.text = post.body
    }

    // MARK: - Actions

    @objc private func likeTapped() {
        guard var p = currentPost else { return }
        p.isLiked.toggle()
        animateLikeChange(post: p)
    }

    @objc private func doubleTapOnImage() {
        guard var p = currentPost else { return }
        // Двойной тап тоже переключает лайк
        p.isLiked.toggle()
        animateLikeChange(post: p)
    }

    private func animateLikeChange(post: Post) {
        // Обновим UI
        currentPost = post
        configure(with: post)
        // Анимация
        UIView.animate(withDuration: 0.15, animations: {
            self.likeButton.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        }, completion: { _ in
            UIView.animate(withDuration: 0.15) {
                self.likeButton.transform = .identity
            }
        })
        onLikeTapped?(post)
    }
}
