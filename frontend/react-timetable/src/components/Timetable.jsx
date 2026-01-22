import { useState, useMemo } from 'react';
import ReservationCard from './ReservationCard';
import ReservationModal from './ReservationModal';

// 시간 슬롯 생성 (06:00 ~ 18:00)
const generateTimeSlots = () => {
  const slots = [];
  for (let hour = 6; hour <= 18; hour++) {
    const time = `${hour.toString().padStart(2, '0')}:00`;
    slots.push(time);
  }
  return slots;
};

export default function Timetable({ reservations }) {
  const [selectedReservation, setSelectedReservation] = useState(null);
  const [isModalOpen, setIsModalOpen] = useState(false);

  const timeSlots = useMemo(() => generateTimeSlots(), []);

  // 시간별로 예약 그룹화
  const reservationsByTime = useMemo(() => {
    const grouped = {};
    timeSlots.forEach(time => {
      grouped[time] = [];
    });

    reservations.forEach(reservation => {
      const time = reservation.time;
      if (grouped[time]) {
        grouped[time].push(reservation);
      }
    });

    return grouped;
  }, [reservations, timeSlots]);

  const handleCardClick = (reservation) => {
    setSelectedReservation(reservation);
    setIsModalOpen(true);
  };

  const handleCloseModal = () => {
    setIsModalOpen(false);
    setSelectedReservation(null);
  };

  // 전체 예약 수 계산
  const totalReservations = reservations.length;
  const totalPeople = reservations.reduce((sum, r) => sum + r.count, 0);

  return (
    <div className="w-full max-w-6xl mx-auto">
      {/* 헤더 요약 정보 */}
      <div className="mb-6 p-4 bg-white rounded-xl shadow-sm border border-gray-100">
        <div className="flex items-center justify-between flex-wrap gap-4">
          <h1 className="text-2xl font-bold text-gray-800">
            오늘의 예약 현황
          </h1>
          <div className="flex gap-6">
            <div className="text-center">
              <p className="text-sm text-gray-500">총 예약</p>
              <p className="text-2xl font-bold text-blue-600">{totalReservations}건</p>
            </div>
            <div className="text-center">
              <p className="text-sm text-gray-500">총 인원</p>
              <p className="text-2xl font-bold text-purple-600">{totalPeople}명</p>
            </div>
          </div>
        </div>
      </div>

      {/* 타임테이블 */}
      <div className="bg-white rounded-xl shadow-lg overflow-hidden border border-gray-100">
        {/* 테이블 헤더 */}
        <div className="grid grid-cols-[100px_1fr] bg-gradient-to-r from-blue-500 to-purple-500 text-white">
          <div className="p-4 font-semibold text-center border-r border-white/20">
            시간
          </div>
          <div className="p-4 font-semibold">
            예약 내역
          </div>
        </div>

        {/* 시간별 행 */}
        <div className="divide-y divide-gray-100">
          {timeSlots.map((time, timeIndex) => {
            const timeReservations = reservationsByTime[time];
            const hasReservations = timeReservations.length > 0;

            return (
              <div
                key={time}
                className={`
                  grid grid-cols-[100px_1fr] min-h-[80px]
                  ${timeIndex % 2 === 0 ? 'bg-white' : 'bg-gray-50/50'}
                  hover:bg-blue-50/30 transition-colors
                `}
              >
                {/* 시간 컬럼 */}
                <div className="p-4 border-r border-gray-100 flex items-center justify-center">
                  <span className={`
                    text-lg font-mono font-semibold
                    ${hasReservations ? 'text-blue-600' : 'text-gray-400'}
                  `}>
                    {time}
                  </span>
                </div>

                {/* 예약 내역 컬럼 */}
                <div className="p-3">
                  {hasReservations ? (
                    <div className="flex flex-wrap gap-3">
                      {timeReservations.map((reservation, index) => (
                        <ReservationCard
                          key={reservation.id}
                          reservation={reservation}
                          index={index}
                          onClick={handleCardClick}
                        />
                      ))}
                    </div>
                  ) : (
                    <div className="flex items-center justify-center h-full text-gray-300 text-sm">
                      예약 없음
                    </div>
                  )}
                </div>
              </div>
            );
          })}
        </div>
      </div>

      {/* 안내 문구 */}
      <div className="mt-4 text-center text-sm text-gray-500">
        예약 카드를 클릭하면 상세 정보를 확인할 수 있습니다.
      </div>

      {/* 모달 */}
      <ReservationModal
        reservation={selectedReservation}
        isOpen={isModalOpen}
        onClose={handleCloseModal}
      />
    </div>
  );
}
