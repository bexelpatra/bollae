import Timetable from './components/Timetable';

// 샘플 예약 데이터
const sampleReservations = [
  {
    id: 1,
    time: "09:00",
    name: "김철수",
    count: 4,
    phone: "010-1234-5678",
    detail: "창가 자리 부탁드립니다."
  },
  {
    id: 2,
    time: "09:00",
    name: "이영희",
    count: 2,
    phone: "010-9876-5432",
    detail: "아기 의자 1개 필요합니다."
  },
  {
    id: 3,
    time: "10:00",
    name: "박민수",
    count: 6,
    phone: "010-5555-1234",
    detail: "생일 파티 예정입니다. 케이크 보관 가능할까요?"
  },
  {
    id: 4,
    time: "11:00",
    name: "최지은",
    count: 3,
    phone: "010-7777-8888",
    detail: "비건 메뉴 가능한지 확인 부탁드립니다."
  },
  {
    id: 5,
    time: "11:00",
    name: "정호진",
    count: 2,
    phone: "010-3333-4444",
    detail: ""
  },
  {
    id: 6,
    time: "12:00",
    name: "강수현",
    count: 8,
    phone: "010-2222-9999",
    detail: "단체석 준비 부탁드립니다. 회사 점심 모임입니다."
  },
  {
    id: 7,
    time: "12:00",
    name: "윤재석",
    count: 4,
    phone: "010-1111-2222",
    detail: "조용한 자리 부탁드립니다."
  },
  {
    id: 8,
    time: "12:00",
    name: "송미나",
    count: 2,
    phone: "010-6666-7777",
    detail: "알러지가 있어서 견과류 제외 부탁드립니다."
  },
  {
    id: 9,
    time: "13:00",
    name: "임동현",
    count: 5,
    phone: "010-4444-5555",
    detail: "야외석 가능하면 좋겠습니다."
  },
  {
    id: 10,
    time: "14:00",
    name: "한소영",
    count: 2,
    phone: "010-8888-9999",
    detail: ""
  },
  {
    id: 11,
    time: "17:00",
    name: "오현우",
    count: 10,
    phone: "010-1234-9876",
    detail: "저녁 단체 회식입니다. 프로젝터 사용 가능한지 확인 부탁드립니다."
  },
  {
    id: 12,
    time: "18:00",
    name: "신예진",
    count: 2,
    phone: "010-5678-1234",
    detail: "프로포즈 예정입니다. 분위기 연출 도움 부탁드립니다."
  },
];

function App() {
  return (
    <div className="min-h-screen bg-gradient-to-br from-slate-50 to-blue-50 py-8 px-4">
      <Timetable reservations={sampleReservations} />
    </div>
  );
}

export default App;
