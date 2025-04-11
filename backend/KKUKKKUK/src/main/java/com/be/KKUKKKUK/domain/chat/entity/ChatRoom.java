package com.be.KKUKKKUK.domain.chat.entity;

import com.be.KKUKKKUK.domain.hospital.entity.Hospital;
import jakarta.persistence.*;
import jakarta.validation.constraints.Email;
import lombok.*;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;


/**
 * packageName    : com.be.KKUKKKUK.domain.chat.entity<br>
 * fileName       : ChatRoom.java<br>
 * author         : haelim <br>
 * date           : 2025-04-09<br>
 * description    : Chat entity class 입니다.<br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.04.09          haelim           최초생성<br>
 */
@Entity
@Table(name = "chatroom")
@Builder
@Getter
@Setter
@ToString
@NoArgsConstructor
@AllArgsConstructor
@EntityListeners(AuditingEntityListener.class)
public class ChatRoom {

    @Id
    @Column(nullable = false, updatable = false)
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @CreatedDate
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "initiator_hospital_id")
    private Hospital initiatorHospital;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "receiver_hospital_id")
    private Hospital receiverHospital;

    @Column(name = "last_message_at")
    private LocalDateTime lastMessageAt;

    @Column(name = "flag_active", nullable = false)
    private Boolean flagActive = true;

    @OneToMany(mappedBy = "chatRoom", cascade = CascadeType.ALL)
    private List<Chat> messages = new ArrayList<>();
}