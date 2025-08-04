import 'encyclopedia_model.dart';

List<Encyclopedia> encyclopediaSamples = [
  Encyclopedia(
    title: "Tập luyện buổi sáng hay tối tốt hơn?",
    category: "Tập luyện",
    content: '''
• Sáng
  – Ưu điểm: tỉnh táo, ít bị kẹt lịch, dễ duy trì thói quen → hợp mục tiêu giảm mỡ.
  – Nhược điểm: sức mạnh/độ linh hoạt chưa tối ưu; cần khởi động kỹ hơn.
• Tối
  – Ưu điểm: thân nhiệt/khớp đã ấm → hiệu suất & sức mạnh thường cao hơn.
  – Nhược điểm: dễ trễ giờ; có thể ảnh hưởng giấc ngủ nếu tập sát giờ.
• Gợi ý chọn thời điểm
  – Ưu tiên kỷ luật/giảm mỡ → tập sáng.
  – Ưu tiên sức mạnh/PR → tập chiều tối (17:00–20:00).
• Mẹo
  – Giữ lịch cố định ≥ 4 tuần để cơ thể thích nghi.
  – Tập tối: kết thúc trước khi ngủ 2–3 giờ; hạn chế caffeine sau 15:00.
''',
    tags: "tập luyện, sáng, tối, lịch tập",
    imageUrl: "assets/encyclopedia/legpractice.webp",
  ),
  Encyclopedia(
    title: "Bổ sung protein sau tập như thế nào?",
    category: "Dinh dưỡng",
    content: '''
• Mục tiêu: 20–40g protein chất lượng trong 0–2 giờ sau tập.
• Gợi ý nhanh
  – Whey 1–1.5 muỗng (24–36g đạm) + 1 quả chuối.
  – 150g ức gà/cá + cơm/khoai + rau xanh.
  – Sữa tươi + sữa chua Hy Lạp + trái cây.
• Đạm cả ngày: 1.6–2.2 g/kg cân nặng, chia 3–5 bữa.
• Mẹo: thêm 20–60g carb sau tập để nạp glycogen; uống đủ nước/điện giải.
''',
    tags: "protein, phục hồi, sau tập",
    imageUrl: "assets/encyclopedia/protein.webp",
  ),
  Encyclopedia(
    title: "Tập cardio thế nào để đốt mỡ tối ưu?",
    category: "Tập luyện",
    content: '''
• Tần suất: 3–5 buổi/tuần, 25–45 phút/buổi.
• Hai phương pháp hiệu quả
  – HIIT: 8–12 hiệp (30s rất nhanh + 60–90s chậm) → 15–20 phút; 2–3 buổi/tuần.
  – Cardio vừa: chạy/đạp mức nói chuyện khó (Zone 2–3) 30–45 phút; 2–4 buổi/tuần.
• Kết hợp: tập tạ + thiếu calo nhẹ (–300 đến –500 kcal/ngày) để giữ cơ.
• Lưu ý: quá nhiều cardio có thể mất cơ; tập bụng nhiều không “đốt mỡ bụng”.
• Nhịp tim mục tiêu: 60–80% HRmax (HRmax ≈ 220 – tuổi).
''',
    tags: "cardio, đốt mỡ, HIIT, chạy bộ",
    imageUrl: "assets/encyclopedia/cardio.webp",
  ),
  Encyclopedia(
    title: "Uống bao nhiêu nước mỗi ngày khi tập gym?",
    category: "Phục hồi",
    content: '''
• Nhu cầu cơ bản: 30–40 ml/kg/ngày (70kg → 2.1–2.8L).
• Khi tập: 200–300 ml mỗi 15–20 phút; ra mồ hôi nhiều → thêm điện giải (Na/K/Mg).
• Dấu hiệu đủ nước: nước tiểu vàng nhạt; không chuột rút/chóng mặt.
• Mẹo: mang bình 1L; dùng viên điện giải cho buổi tập nặng hoặc thời tiết nóng.
''',
    tags: "nước, phục hồi, mất nước",
    imageUrl: "assets/encyclopedia/water.webp",
  ),
  Encyclopedia(
    title: "Tập gym khi đang giảm cân nên ăn như thế nào?",
    category: "Dinh dưỡng",
    content: '''
• Mục tiêu: thiếu calo nhẹ –300 đến –500 kcal/ngày → giảm mỡ, giữ cơ.
• Đạm: 1.6–2.2 g/kg/ngày (thịt nạc, cá, trứng, sữa, đậu).
• Carb: ưu tiên nguyên cám; bố trí quanh buổi tập để có sức.
• Chất béo: 0.6–1 g/kg/ngày từ dầu olive, quả bơ, hạt, cá béo.
• Rau/xơ: ≥ 400g rau & 2–3 phần trái cây/ngày → no lâu, vi chất đủ.
• Mẹo: ăn chậm, theo dõi TDEE/khẩu phần; ngủ đủ để kiểm soát thèm ăn.
''',
    tags: "giảm cân, dinh dưỡng, ăn kiêng",
    imageUrl: "assets/encyclopedia/eatandgym.webp",
  ),
  Encyclopedia(
    title: "Tại sao nên nghỉ đủ ngày khi tập gym?",
    category: "Phục hồi",
    content: '''
• Cơ bắp phát triển trong lúc nghỉ, không phải lúc nâng tạ.
• Lợi ích: phục hồi sợi cơ, nạp glycogen, giảm chấn thương & kiệt sức.
• Lịch gợi ý: 1–2 ngày nghỉ/tuần; mỗi 6–8 tuần có 1 tuần deload (giảm 30–50% khối lượng).
• Dấu hiệu cần nghỉ: ngủ kém, nhịp tim nghỉ tăng, đau dai dẳng, tụt thành tích.
• Ngày nghỉ nên làm gì: đi bộ nhẹ, kéo giãn, ăn đủ đạm, uống đủ nước.
''',
    tags: "nghỉ ngơi, phục hồi, chấn thương",
    imageUrl: "assets/encyclopedia/restday.webp",
  ),
  Encyclopedia(
    title: "Warm-up có cần thiết không?",
    category: "Tập luyện",
    content: '''
• Mục tiêu: tăng nhiệt, đánh thức khớp – cơ – hệ thần kinh, giảm chấn thương.
• Khung RAMP (5–10 phút)
  – Raise: làm ấm (đi bộ nhanh/nhảy dây nhẹ 2–3’).
  – Activate/Mobilize: kích hoạt + linh hoạt (glute bridge, band pull-apart, hip opener…).
  – Potentiate: set khởi động giống bài chính (2–3 set nhẹ tăng dần).
• Ví dụ buổi tạ chân: 2’ đạp xe nhẹ → 2×12 glute bridge + 2×12 bodyweight squat → 2 set squat 40–60% tạ làm nóng.
''',
    tags: "khởi động, warm-up, an toàn",
    imageUrl: "assets/encyclopedia/warmup.webp",
  ),
  Encyclopedia(
    title: "Creatine là gì và có an toàn không?",
    category: "Dinh dưỡng",
    content: '''
• Lợi ích: tăng sức mạnh/ngắn hạn, thể tích cơ (giữ nước nội bào), cải thiện phục hồi.
• Liều: 3–5 g/ngày (duy trì). Tùy chọn “tải” 20 g/ngày × 5–7 ngày rồi 3–5 g/ngày.
• Thời điểm: bất kỳ; quan trọng là dùng đều đặn + uống 2–3L nước/ngày.
• Dạng khuyên dùng: Creatine Monohydrate (hiệu quả & tiết kiệm).
• An toàn: bằng chứng mạnh ở liều khuyến cáo; hỏi bác sĩ nếu có bệnh thận.
''',
    tags: "creatine, supplement, hiệu suất",
    imageUrl: "assets/encyclopedia/creatine.webp",
  ),
  Encyclopedia(
    title: "Ngủ ít ảnh hưởng thế nào đến tăng cơ?",
    category: "Phục hồi",
    content: '''
• Thiếu ngủ → giảm GH/Testosterone, tăng cortisol → phục hồi kém, dễ tích mỡ.
• Khuyến nghị: 7–9 giờ/đêm; cố định giờ ngủ – dậy; phòng tối, mát, yên.
• Mẹo: hạn chế caffeine sau 15:00; tắt màn hình xanh trước ngủ 60–90’; tắm ấm/đọc nhẹ.
• Dấu hiệu thiếu ngủ: đói vặt, lờ đờ, tập tụt → hãy giảm khối lượng tập và ưu tiên ngủ.
''',
    tags: "ngủ, tăng cơ, stress",
    imageUrl: "assets/encyclopedia/sleep.webp",
  ),
  Encyclopedia(
    title: "Cách đo chỉ số cơ thể cơ bản",
    category: "Tập luyện",
    content: '''
• Chỉ số nên biết
  – BMI: nhanh & tổng quát, không phản ánh % mỡ.
  – BMR/TDEE: ước lượng năng lượng cần thiết → lập kế hoạch calo.
  – % mỡ cơ thể: quan trọng cho sức khỏe/hình thể.
• Theo dõi thực tế
  – Đo vòng eo qua rốn, chụp ảnh cùng điều kiện (ánh sáng/đứng thẳng) mỗi 2–4 tuần.
  – Cân buổi sáng sau đi vệ sinh, trước ăn; so xu hướng 7–14 ngày, đừng nhìn từng ngày.
  – Dùng thước dây/cân thông minh nhất quán; không đổi công cụ giữa chừng.
''',
    tags: "BMI, TDEE, bodyfat, cơ thể",
    imageUrl: "assets/encyclopedia/measurement.webp",
  ),
  Encyclopedia(
    title: "Form squat cơ bản cho người mới",
    category: "Tập luyện",
    content: '''
• Mục tiêu: an toàn – ổn định – chiều sâu phù hợp (đùi song song sàn trở xuống).
• Thiết lập
  – Chân rộng bằng vai, mũi chân xoay 5–20°, nén bụng, ức mở.
  – Thanh đòn đặt trên lưng trên (high-bar) hoặc vai sau (low-bar) tùy người.
• Thực hiện
  – Hít vào – khóa core – ngồi xuống đồng thời gối/hông, đầu gối hướng theo mũi chân.
  – Đẩy sàn đứng lên, thở ra cuối động tác.
• Lưu ý
  – Gối không sụp vào trong, lưng không gù; tăng tạ dần (progressive overload).
''',
    tags: "squat, form, kỹ thuật, lower body",
    imageUrl: "assets/encyclopedia/squat.webp",
  ),
  Encyclopedia(
    title: "Form deadlift an toàn",
    category: "Tập luyện",
    content: '''
• Mục tiêu: kéo bằng hông – lưng trung lập – thanh đòn sát ống chân.
• Thiết lập
  – Chân rộng bằng hông, nắm đòn ngay ngoài gối, vai ngay trước đòn.
  – Kéo slack: siết thanh, nén bụng, hông không quá thấp.
• Thực hiện
  – Đạp sàn + mở hông đồng thời, thanh trượt sát chân, không ngửa lưng quá mức ở đỉnh.
• Lưu ý: không giật tạ khỏi sàn; reset từng rep khi cần.
''',
    tags: "deadlift, form, kỹ thuật, posterior chain",
    imageUrl: "assets/encyclopedia/deadlift.webp",
  ),
  Encyclopedia(
    title: "Form bench press hiệu quả",
    category: "Tập luyện",
    content: '''
• Thiết lập: bả vai kéo về sau – xuống dưới (retract/depress), 2 chân vững trên sàn.
• Độ rộng tay: cẳng tay thẳng đứng ở nửa dưới; chạm ngực khoảng vùng núm/đường dưới ngực.
• Quỹ đạo: chữ J nhẹ; khuỷu ~45–70° so với thân.
• Lưu ý: giữ căng lưng trên, không bật hông; dùng spotter khi nặng.
''',
    tags: "bench press, form, ngực, đẩy tạ",
    imageUrl: "assets/encyclopedia/bench.webp",
  ),
  Encyclopedia(
    title: "Lịch tập 3–4 buổi/tuần cho người mới",
    category: "Tập luyện",
    content: '''
• Tuần 3 buổi (Full body)
  – Buổi A: Squat – Bench – Row – Core.
  – Buổi B: Deadlift – Overhead Press – Lat Pulldown – Core.
  – Xen kẽ A/B, mỗi bài 3×6–10, tăng tạ nhẹ mỗi tuần.
• Tuần 4 buổi (Upper/Lower)
  – Lower A/B: Squat/Deadlift + phụ trợ chân.
  – Upper A/B: Bench/Overhead Press + kéo lưng – tay.
''',
    tags: "lịch tập, beginner, full body, upper lower",
    imageUrl: "assets/encyclopedia/schedule.webp",
  ),
  Encyclopedia(
    title: "Progressive overload là gì?",
    category: "Tập luyện",
    content: '''
• Khái niệm: tăng dần kích thích theo thời gian → cơ thể thích nghi và tiến bộ.
• Cách tăng
  – Tăng tạ 2.5–5% khi đạt cuối thang reps.
  – Thêm 1–2 rep, thêm 1 set, hoặc rút ngắn nghỉ.
• Theo dõi: ghi chép tạ/reps/set; giữ form trước, tăng sau.
''',
    tags: "progressive overload, tăng tạ, tiến bộ",
    imageUrl: "assets/encyclopedia/progressive.webp",
  ),
  Encyclopedia(
    title: "Tính calo & macro nhanh",
    category: "Dinh dưỡng",
    content: '''
• Bước 1: Ước TDEE (công cụ/ công thức Mifflin-St Jeor).
• Bước 2: Chọn mục tiêu
  – Giảm mỡ: TDEE – 300 đến –500 kcal/ngày.
  – Tăng cơ: TDEE + 150–300 kcal/ngày (sạch).
• Macro gợi ý
  – Protein: 1.6–2.2 g/kg.
  – Fat: 0.6–1.0 g/kg.
  – Carb: phần còn lại theo TDEE.
''',
    tags: "calo, macro, TDEE, dinh dưỡng",
    imageUrl: "assets/encyclopedia/macro.webp",
  ),
  Encyclopedia(
    title: "Bộ supplement cơ bản cho người tập",
    category: "Dinh dưỡng",
    content: '''
• Hiệu quả – kinh tế
  – Whey/đạm tiện lợi để đủ protein.
  – Creatine Monohydrate 3–5 g/ngày.
  – Caffeine 2–3 mg/kg trước tập (tuỳ dung nạp).
• Tùy chọn: điện giải khi ra mồ hôi nhiều; vitamin D nếu thiếu; fish oil 1–2 g EPA+DHA/ngày.
• Không cần: sản phẩm “đốt mỡ” mạnh – ưu tiên dinh dưỡng & kỷ luật.
''',
    tags: "supplement, whey, caffeine, fish oil",
    imageUrl: "assets/encyclopedia/supplement.webp",
  ),
  Encyclopedia(
    title: "Pre-workout: uống khi nào và bao nhiêu?",
    category: "Dinh dưỡng",
    content: '''
• Thành phần có căn cứ: caffeine, beta-alanine, citrulline malate, điện giải.
• Thời điểm
  – Caffeine: 30–45 phút trước tập.
  – Bữa nhỏ carb dễ tiêu (chuối, bánh mì) 60–90 phút trước.
• Lưu ý: theo dõi nhịp tim/giấc ngủ; không nên dùng muộn sau 16:00.
''',
    tags: "pre-workout, caffeine, thời điểm",
    imageUrl: "assets/encyclopedia/preworkout.webp",
  ),
  Encyclopedia(
    title: "DOMS: đau cơ muộn là gì?",
    category: "Phục hồi",
    content: '''
• DOMS = đau căng cơ 24–72 giờ sau buổi tập mới/nặng.
• Bình thường: dấu hiệu thích nghi; không phải tiêu chuẩn “tập tốt”.
• Giảm DOMS
  – Tăng tải dần, warm-up kỹ, giãn động, ngủ đủ, nạp đủ đạm & nước.
  – Đi bộ nhẹ, bơi, xoa bóp, tắm ấm có thể giảm khó chịu.
''',
    tags: "DOMS, phục hồi, đau cơ",
    imageUrl: "assets/encyclopedia/doms.webp",
  ),
  Encyclopedia(
    title: "Vai đau khi tập đẩy: cách phòng & xử lý",
    category: "Phục hồi",
    content: '''
• Nguyên nhân thường gặp: thiếu ổn định bả vai, range quá sâu, khớp tiền sử chấn thương.
• Phòng ngừa
  – Kỹ thuật bench/overhead press đúng; tăng tải dần.
  – Bài bổ trợ: face pull, external rotation, scapula push-up.
• Xử lý: giảm khối lượng/biên độ, đá lạnh 10–15’, tham khảo chuyên gia nếu đau kéo dài.
''',
    tags: "vai, chấn thương, bench, phục hồi",
    imageUrl: "assets/encyclopedia/shoulder.webp",
  ),
  Encyclopedia(
    title: "Mobility vs Stretching: nên làm gì?",
    category: "Phục hồi",
    content: '''
• Giãn động (dynamic stretching): trước buổi tập → tăng nhiệt & range an toàn.
• Mobility (kiểm soát tầm vận động có lực): xen kẽ ngày nghỉ/đầu buổi.
• Giãn tĩnh: sau buổi tập hoặc thời điểm riêng, 20–60s/nhóm cơ.
• Mục tiêu: cải thiện biên độ có kiểm soát để form tốt & giảm chấn thương.
''',
    tags: "mobility, stretching, giãn cơ, warmup",
    imageUrl: "assets/encyclopedia/mobility.webp",
  ),
  Encyclopedia(
    title: "Recomp: vừa giảm mỡ vừa tăng cơ có khả thi?",
    category: "Phục hồi",
    content: '''
• Có, khi: mới tập/ quay lại sau nghỉ dài/ % mỡ cao/ ngủ & dinh dưỡng tốt.
• Nguyên tắc
  – Protein 1.8–2.2 g/kg, thiếu calo nhẹ hoặc quanh mức bảo trì.
  – Progressive overload + theo dõi số đo/ảnh tiến trình.
• Kỳ vọng: tiến bộ chậm nhưng bền; điều chỉnh theo dữ liệu 4–6 tuần.
''',
    tags: "recomp, tăng cơ giảm mỡ, tiến trình",
    imageUrl: "assets/encyclopedia/recomp.webp",
  ),
];
