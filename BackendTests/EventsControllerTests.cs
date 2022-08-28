using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Xunit;
using Moq;
using CodeEx_DSE.Controllers;
using CodeEx_DSE.Data;
using CodeEx_DSE.Data.Models;

namespace BackendTests
{
    public class EventsControllerTests
    {
        [Fact]
        public async void GetEvents_WhenNoParameters_ReturnsAllEvents()
        {
            var mockEvents = new List<Event>();
            for (int i = 1; i <= 10; i++)
            {
                mockEvents.Add(new Event
                {
                    EventId = 1,
                    EventTitle = $"Test title {i}",
                    EventDescription = $"Test content {i}",
                    CoordinatorId = "User{i}",
                    CoordinatorName = "User name {i}",
                    EventDate = DateTime.UtcNow,
                    EventStatusId = 1,
                    EventStatus = "status {i}",
                    Attendees = new List<EventRegistration>()
                });
            }
            //create a mock data repository definition using Moq
            var mockDataRepository = new Mock<IDataRepository>();
            mockDataRepository.Setup(repo => repo.GetEventMany())
            .Returns(() => Task.FromResult(mockEvents.AsEnumerable())); //The tested method is asynchronous, so wrap the mock events with Task.FromResult

            //mock the configuration object that reads appsettings.json
            var mockConfigurationRoot = new Mock<IConfigurationRoot>();
            mockConfigurationRoot.SetupGet(config => config[It.IsAny<string>()]).Returns("some setting");

            //create an instance of the API controller
            var eventsController = new EventsController(mockDataRepository.Object, null, mockConfigurationRoot.Object);

            var result = await eventsController.GetEvents(null);

            Assert.Equal(10, result.Count());
            mockDataRepository.Verify(mock => mock.GetEventMany(),Times.Once());
        }

        [Fact]
        public async void GetEvents_WhenHaveSearchParameter_ReturnsCorrectEvents()
        {
            var mockEvents = new List<Event>();
            int i = 1;
            mockEvents.Add(new Event
            {
                EventId = 1,
                EventTitle = $"Test title {i}",
                EventDescription = $"Test content {i}",
                CoordinatorId = "User{i}",
                CoordinatorName = "User name {i}",
                EventDate = DateTime.UtcNow,
                EventStatusId = 1,
                EventStatus = "status {i}",
                Attendees = new List<EventRegistration>()
            });

            //create a mock data repository definition using Moq
            var mockDataRepository = new Mock<IDataRepository>();
            mockDataRepository.Setup(repo => repo.GetEventMany_bySearch("Test"))
            .Returns(() => Task.FromResult(mockEvents.AsEnumerable())); //The tested method is asynchronous, so wrap the mock events with Task.FromResult

            var mockConfigurationRoot = new Mock<IConfigurationRoot>();
            mockConfigurationRoot.SetupGet(config => config[It.IsAny<string>()]).Returns("some setting");            

            var eventsController = new EventsController(mockDataRepository.Object, null, mockConfigurationRoot.Object);
            var result = await eventsController.GetEvents("Test");

            Assert.Single(result);

            mockDataRepository.Verify(mock => mock.GetEventMany_bySearch("Test"), Times.Once());
        }

    }
}
