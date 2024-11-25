// 구매자 정보 가져오기 (DB에서 처리된 값)
const username = "<%= mealkitvo.getId() %>";
const useremail = "<%= mealkitvo.getEmail() %>";

// 결제 버튼 이벤트 연결
const buyButton = document.getElementById('payment');

// 클릭 이벤트 리스너 추가
buyButton.addEventListener('click', function() {
    kakaoPay(useremail, username);
});

// 고유한 결제 번호 생성
var today = new Date();
var hours = today.getHours();
var minutes = today.getMinutes();
var seconds = today.getSeconds();
var milliseconds = today.getMilliseconds();
var makeMerchantUid = `${hours}${minutes}${seconds}${milliseconds}`;  // 결제 고유 번호

// 카카오페이 결제 함수
function kakaoPay(useremail, username) {
    if (confirm("구매 하시겠습니까?")) {
        if (localStorage.getItem("access")) {  // 로그인 상태 확인
            const emoticonName = document.getElementById('title').innerText; // 상품명 (예시: product title)

            IMP.init("imp78768038");

            // 결제 요청
            IMP.request_pay({
                pg: 'kakaopay.TC0ONETIME',  // PG사 코드
                pay_method: 'card',          // 결제 방식
                merchant_uid: "IMP" + makeMerchantUid, // 결제 고유 번호
                name: emoticonName,          // 상품명
                amount: 100,                 // 가격 (예시)
                buyer_email: useremail,      // 구매자 이메일
                buyer_name: username,        // 구매자 이름
            }, async function(rsp) { // 결제 요청 후 callback 처리
                if (rsp.success) {  // 결제 성공 시
                    console.log(rsp); // 결제 성공 시 응답 로그

                    // 프로젝트 DB 저장 요청
                    try {
                        let response = await savePaymentToDB(rsp, useremail, username);

                        if (response.status == 200) {  // DB 저장 성공
                            alert('결제 완료!');
                            window.location.reload();
                        } else {  // DB 저장 실패
                            alert(`error:[${response.status}]\n결제 요청이 승인된 경우 관리자에게 문의 바랍니다.`);
                        }
                    } catch (error) {
                        console.error('결제 DB 저장 중 오류 발생:', error);
                    }
                } else {  // 결제 실패 시
                    alert(rsp.error_msg);
                }
            });
        } else {  // 비회원 결제 불가
            alert('로그인이 필요합니다!');
        }
    } else {  // 구매 확인 취소 시
        return false;
    }
}
