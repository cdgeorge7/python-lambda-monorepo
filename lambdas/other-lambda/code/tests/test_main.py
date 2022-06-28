from code.main import handler
from unittest import TestCase


class TestOtherLambda(TestCase):
    def test_it_works(self):
        handler(None, None)
        self.assertTrue(True)
