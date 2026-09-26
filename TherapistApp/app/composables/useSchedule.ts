import type { ScheduleDay } from '~/data/dummy'
import { initialSchedule } from '~/data/dummy'

export function useSchedule() {
  const schedule = useState<ScheduleDay[]>('work-schedule', () => JSON.parse(JSON.stringify(initialSchedule)))

  function toggleDay(day: string) {
    const entry = schedule.value.find((d) => d.day === day)
    if (entry) entry.active = !entry.active
  }

  function updateHours(day: string, start: string, end: string) {
    const entry = schedule.value.find((d) => d.day === day)
    if (entry) {
      entry.start = start
      entry.end = end
    }
  }

  return { schedule, toggleDay, updateHours }
}
