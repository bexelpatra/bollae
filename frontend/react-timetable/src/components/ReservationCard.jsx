import { useState } from 'react';

// 파스텔 색상 배열
const pastelColors = [
  'bg-pink-100 border-pink-300',
  'bg-blue-100 border-blue-300',
  'bg-green-100 border-green-300',
  'bg-yellow-100 border-yellow-300',
  'bg-purple-100 border-purple-300',
  'bg-orange-100 border-orange-300',
  'bg-teal-100 border-teal-300',
  'bg-indigo-100 border-indigo-300',
];

export default function ReservationCard({ reservation, index, onClick }) {
  const colorClass = pastelColors[index % pastelColors.length];

  return (
    <div
      onClick={() => onClick(reservation)}
      className={`
        ${colorClass}
        border-2 rounded-lg p-3 cursor-pointer
        hover:shadow-md hover:scale-[1.02]
        transition-all duration-200 ease-in-out
        min-w-[140px] flex-1
      `}
    >
      {/* 요약 정보 */}
      <div className="space-y-1">
        <div className="flex items-center gap-2">
          <span className="text-lg font-semibold text-gray-800">
            {reservation.time}
          </span>
        </div>
        <div className="text-sm font-medium text-gray-700">
          {reservation.name}
        </div>
        <div className="flex items-center gap-1 text-sm text-gray-600">
          <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z" />
          </svg>
          <span>{reservation.count}명</span>
        </div>
      </div>

      {/* 클릭 안내 */}
      <div className="mt-2 text-xs text-gray-500 flex items-center gap-1">
        <svg className="w-3 h-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
        </svg>
        상세 보기
      </div>
    </div>
  );
}
