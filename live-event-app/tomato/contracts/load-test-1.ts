import { rand, randUuid, randDatabaseType, randFirstName } from '@ngneat/falso'
import { envelope, successfulResponse, timetokenData } from '../utils/subscribe'

export const name = 'loadTest'

const SUB_KEY = 'demo'

const MSGS_PER_SECOND = 100000
const CHANNEL = 'demo'
const CONCURRENT_USERS = 4
const CHUNKS_PER_SECOND = 100
const MSGS_PER_CHUNK = MSGS_PER_SECOND / CHUNKS_PER_SECOND
const CHUNK_DELAY_MS = (1 / CHUNKS_PER_SECOND) * 1000

const users = Array.from(Array(CONCURRENT_USERS), () => ({
  uuid: randUuid(),
}))

function generatePayload(currentItemIndex: number) {
  return {
    id: randUuid(),
    text: "Lorem ipsum dolor sit amet",
    createdAt: (new Date().toISOString())
  }
}

function generateEnvelopes(startTimetoken: string, amount: number) {
  const result = []
  let start = BigInt(startTimetoken)

  for (let i = 0; i < amount; i++) {
    const messageTimetoken = (start++).toString()
    const user = rand(users)

    result.push(
      envelope({
        channel: CHANNEL,
        sender: "user_0",
        subKey: SUB_KEY,
        publishingTimetoken: {
          t: messageTimetoken,
          r: 0,
        },
        payload: generatePayload(i),
      })
    )
  }

  return result
}

export default async function () {
  let currentTimetoken = timetoken.now()

  const request = await expect({
    description: 'subscribe with timetoken zero',
    validations: [],
  })

  await request.respond({
    status: 200,
    body: successfulResponse(timetokenData(currentTimetoken)),
  })

  while (true) {
    await Promise.race([
      sleep(CHUNK_DELAY_MS),
      expect({
        description: 'subscribe next',
        validations: [],
      }).then(async (request) => {
        const envelopes = generateEnvelopes(currentTimetoken, MSGS_PER_CHUNK)

        const nextTimetoken = timetoken.now()

        await request.respond({
          status: 200,
          body: successfulResponse(timetokenData(nextTimetoken), envelopes),
        })

        currentTimetoken = nextTimetoken
      }),
    ])
  }
}
