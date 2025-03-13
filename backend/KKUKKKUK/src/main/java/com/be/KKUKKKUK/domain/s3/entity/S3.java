package com.be.KKUKKKUK.domain.s3.entity;

import com.be.KKUKKKUK.global.enumeration.RelatedType;
import jakarta.persistence.*;
import lombok.*;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import java.time.LocalDateTime;

/**
 * packageName    : com.be.KKUKKKUK.domain.s3.entity<br>
 * fileName       : S3.java<br>
 * author         : Fiat_lux<br>
 * date           : 2025-03-13<br>
 * description    :  s3 entity class 입니다.<br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.03.13          Fiat_lux           최초생성<br>
 */
@Entity
@Table(name = "s3")
@Getter
@Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@EntityListeners(AuditingEntityListener.class)
public class S3 {
    @Id
    @Column(nullable = false)
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(name = "related_type", nullable = false, length = 7)
    @Enumerated(EnumType.STRING)
    private RelatedType relatedType;

    @Column(name = "related_id", nullable = false)
    private Integer relatedId;

    @Column(nullable = false)
    private String url;

    @CreatedDate
    @Column(name = "created_at", nullable = false)
    private LocalDateTime createdAt;
}
