package com.be.KKUKKKUK.domain.chat.entity;

import com.be.KKUKKKUK.domain.hospital.entity.Hospital;
import jakarta.persistence.*;
import lombok.*;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import java.time.LocalDateTime;


/**
 * packageName    : com.be.KKUKKKUK.domain.Chat.entity<br>
 * fileName       : Chat.java<br>
 * author         : haelim <br>
 * date           : 2025-04-09<br>
 * description    : Chat entity class 입니다.<br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.04.09          haelim           최초생성<br>
 */
@Entity
@Table(name = "chat")
@Builder
@Getter
@Setter
@ToString(exclude = "chatRoom")
@NoArgsConstructor
@AllArgsConstructor
@EntityListeners(AuditingEntityListener.class)
public class Chat {

    @Id
    @Column(nullable = false, updatable = false)
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(nullable = false, columnDefinition = "TEXT")
    private String content;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "sender_hospital_id", nullable = false)
    private Hospital sender;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "chatroom_id", nullable = false)
    private ChatRoom chatRoom;

    @CreatedDate
    @Column(name = "sent_at", nullable = false, updatable = false)
    private LocalDateTime sentAt;

    @Column(name = "flag_read", nullable = false)
    private Boolean flagRead = false;

    @Column(name = "read_at")
    private LocalDateTime readAt;
}